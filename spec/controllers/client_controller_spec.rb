require 'spec_helper'

describe ClientController do 
  it { should respond_to(:index) }
  it { should respond_to(:create) }
  it { should respond_to(:update) }
  it { should respond_to(:show) }
end