require 'spec_helper'

describe Importer do
end

describe String do
  
  it "should provide nicenames" do
    { "Centro" => "centro",
      "Entrevías" => "entrevias",
      "El Pardo" => "el-pardo" }.each do |name, nicename|
      name.nicename.should == nicename
    end
  end
end
