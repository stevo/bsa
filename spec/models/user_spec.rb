require 'spec_helper'

describe User do
  subject { build(:user) }

  it { expect(subject).to respond_to(:password, :password_confirmation, :encrypted_password) }

  it "creates a new instance given a valid attribute" do
    expect { User.create!(attributes_for(:user)) }.to_not raise_error
  end

  context "validations" do
    context "user has no email address" do
      let(:user) { build(:user, email: '') }

      it { expect(user).to_not be_valid }
    end

    context "user has valid email address" do
      %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp].each do |valid_address|
        let(:user) { build(:user, email: valid_address) }

        it { expect(user).to be_valid }
      end
    end

    context "user has invalid email address" do
      %w[user@foo,com user_at_foo.org example.user@foo.].each do |valid_address|
        let(:user) { build(:user, email: valid_address) }

        it { expect(user).to_not be_valid }
      end
    end

    context "user already exists with given email address" do
      let(:duplicate_address) { 'duplicate@address.com' }
      before { create(:user, email: duplicate_address) }
      let(:user) { build(:user, email: duplicate_address) }

      it { expect(user).to_not be_valid }
    end

    context "user already exists with given email address but different up case" do
      let(:duplicate_address) { 'duplicate@address.com' }
      before { create(:user, email: duplicate_address) }
      let(:user) { build(:user, email: duplicate_address.upcase) }

      it { expect(user).to_not be_valid }
    end

    context "user has no password set" do
      let(:user) { build(:user, password: "", password_confirmation: "") }

      it { expect(user).to_not be_valid }
    end

    context "user has password set but confirmation does not mathc" do
      let(:user) { build(:user, password: "something", password_confirmation: "else") }

      it { expect(user).to_not be_valid }
    end

    context "user has a password set that is to short" do
      let(:user) { build(:user, password: "short", password_confirmation: "short") }

      it { expect(user).to_not be_valid }
    end
  end

  context "password encryption" do
    let!(:user) { create(:user) }

    it "sets the encrypted password attribute" do
      expect(user.encrypted_password).to_not be_blank
    end
  end

  describe "#guest?" do
    subject { create(:user) }

    context "new user" do
      it { expect(subject.guest?).to be_true }
    end

    context "user has membership" do
      before { create(:membership, user_id: subject.id) }

      it { expect(subject.guest?).to be_false }
    end
  end
end
