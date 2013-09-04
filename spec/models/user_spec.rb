require 'spec_helper'

describe User do
  let(:attrs) do
    {
      name:                  "Example User",
      email:                 "user@example.com",
      password:              "changeme",
      password_confirmation: "changeme"
    }
  end

  it "creates a new instance given a valid attribute" do
    User.create!(attributes_for(:user))
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
      let(:user){ build(:user, email: duplicate_address) }
      it { expect(user).to_not be_valid }
    end
  end

  it "rejects email addresses identical up to case" do
    upcased_email = attrs[:email].upcase
    User.create!(attrs.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(attrs)
    user_with_duplicate_email.should_not be_valid
  end

  describe "passwords" do
    let(:user) { User.new(attrs) }


    it "should have a password attribute" do
      user.should respond_to(:password)
    end

    it "should have a password confirmation attribute" do
      user.should respond_to(:password_confirmation)
    end
  end

  describe "password validations" do

    it "requires a password" do
      User.new(attrs.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "requires a matching password confirmation" do
      User.new(attrs.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end

    it "rejects short passwords" do
      short = "a" * 5
      hash  = attrs.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

  end

  describe "password encryption" do
    let!(:user) { User.create!(attrs) }

    it "should have an encrypted password attribute" do
      user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password attribute" do
      user.encrypted_password.should_not be_blank
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
