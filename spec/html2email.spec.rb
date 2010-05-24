require File.expand_path '../../lib/html2email', __FILE__

describe Html2Email do
  describe :VERSION do
    it 'should contain the version string' do
      Html2Email::VERSION.should =~ /^\d+\.\d+\.\d+$/
    end
  end
end
