require 'spec_helper'

describe User do
  describe "#attr_accessible" do
    it "has 8 attributes" do
      User.attr_accessible[:default].size.should == 7
    end
    it "includes #first_name" do
      User.attr_accessible[:default].include?("first_name").should be_true
    end
    it "includes #last_name" do
      User.attr_accessible[:default].include?("last_name").should be_true
    end
    it "includes #email" do
      User.attr_accessible[:default].include?("email").should be_true
    end
    it "includes #password" do
      User.attr_accessible[:default].include?("password").should be_true
    end
    it "includes #password_confirmation" do
      User.attr_accessible[:default].include?("password_confirmation").should be_true
    end
    it "includes #remember_me" do
      User.attr_accessible[:default].include?("remember_me").should be_true
    end
  end
end
