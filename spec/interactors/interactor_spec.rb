require 'spec_helper'

describe Interactor do
  let(:controller) { double.as_null_object }

  context 'interaction' do
    let(:interactor) do
      stub_class(described_class) { perform { do_something_on_controller } }
    end

    describe '#perform' do
      subject { interactor.new(controller) }

      it 'calls code from perform block on controller instance' do
        controller.should_receive(:do_something_on_controller)
        subject.perform
      end

      it 'returns the result of called perform block' do
        controller.should_receive(:do_something_on_controller).and_return('some result')
        expect(subject.perform).to eq 'some result'
      end

      context 'condition is given' do
        before do
          interactor.class_eval do
            condition { some_condition }
          end
          controller.stub(some_condition: condition_result)
        end

        context 'condition is not met' do
          let(:condition_result) { false }

          it 'does not call code from perform block on controller instance' do
            controller.should_not_receive(:do_something_on_controller)
            subject.perform
          end
        end

        context 'condition is not met' do
          let(:condition_result) { true }

          it 'does call code from perform block on controller instance' do
            controller.should_receive(:do_something_on_controller)
            subject.perform
          end
        end
      end
    end
  end

  context 'organisation' do
    describe '#perform' do
      context 'interactor 1 exists' do
        before do
          stub_class(described_class, :Interactor1) { perform { do_one_thing_on_controller } }
        end

        context 'interactor 2 exists' do
          before do
            stub_class(described_class, :Interactor2) { perform { do_other_thing_on_controller } }
          end

          let(:organizer) do
            stub_class(described_class) do
              def steps
                [Interactor::Interactor1, Interactor::Interactor2]
              end
            end
          end

          subject { organizer.new(controller) }

          it "all organized interactors are called" do
            controller.should_receive(:do_one_thing_on_controller)
            controller.should_receive(:do_other_thing_on_controller)
            subject.perform
          end

          it "returns last interactor result" do
            controller.should_receive(:do_other_thing_on_controller).and_return("some result")
            expect(subject.perform).to eq 'some result'
          end

          context "first interactor has not passing condition" do
            before { Interactor::Interactor1.class_eval { condition { false } } }

            it "only second interactor is called" do
              controller.should_not_receive(:do_one_thing_on_controller)
              controller.should_receive(:do_other_thing_on_controller)
              subject.perform
            end

            it "returns second interactor result" do
              controller.should_receive(:do_other_thing_on_controller).and_return("some result")
              expect(subject.perform).to eq 'some result'
            end
          end

          context "second interactor has not passing condition" do
            before { Interactor::Interactor2.class_eval { condition { false } } }

            it "only second interactor is called" do
              controller.should_receive(:do_one_thing_on_controller)
              controller.should_not_receive(:do_other_thing_on_controller)
              subject.perform
            end

            it "returns last passing interactor result" do
              controller.should_receive(:do_one_thing_on_controller).and_return("some result")
              expect(subject.perform).to eq 'some result'
            end
          end

          context 'organizer 2 exists' do
            before do
              stub_class(described_class, :Interactor3) { perform { do_third_thing_on_controller } }
            end

            let!(:organizer2) do
              stub_class(described_class, :Organizer2) do
                def steps
                  [Interactor::Interactor3]
                end
              end
            end

            context "organizer 1 contains organizer 2" do
              let(:organizer) do
                stub_class(described_class) do
                  def steps
                    [Interactor::Interactor1, Interactor::Interactor2, Interactor::Organizer2]
                  end
                end
              end

              it "returns last passing interactor result" do
                controller.should_receive(:do_third_thing_on_controller).and_return("organizer result")
                expect(subject.perform).to eq 'organizer result'
              end
            end
          end
        end
      end
    end
  end

  context 'organizer 1 contains 3 interactors' do
    describe '#perform' do
      before do
        %w(first second third).each { |method| controller.stub("do_#{method}_thing") }
        stub_class(described_class, :FirstInteractor) do
          perform do
            do_first_thing
            'First result'
          end
        end

        stub_class(described_class, :SecondInteractor) do
          perform do
            do_second_thing
            'Second value'
          end
        end

        stub_class(described_class, :ThirdInteractor) do
          perform do
            do_third_thing
            'Third value'
          end
        end
      end

      context 'second interactor is breaking' do
        before do
          class Interactor::SecondInteractor
            breaking!
          end
        end

        subject { organizer.new(controller) }

        let(:organizer) do
          stub_class(described_class) do
            def steps
              [Interactor::FirstInteractor, Interactor::SecondInteractor, Interactor::ThirdInteractor]
            end
          end
        end

        it 'returns the value of the second interactor' do
          expect(subject.perform).to eq 'Second value'
        end

        it 'does not return the value of the third interactor' do
          expect(subject.perform).to_not eq 'First value'
        end

        it 'does not return the value of the third interactor' do
          expect(subject.perform).to_not eq 'Third value'
        end

        it 'performs the first interactor' do
          controller.should_receive(:do_first_thing)
          subject.perform
        end

        it 'performs the second interactor' do
          controller.should_receive(:do_second_thing)
          subject.perform
        end

        it 'does not perform the third interactor' do
          controller.should_not_receive(:do_third_thing)
          subject.perform
        end
      end
    end
  end
end
