require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe BitTorrent do

  let(:source) { "magnet:?xt=urn:btih:source" }
  let(:sources) { source }
  let(:options) { {} }
  let(:the_class) { BitTorrent }
  let(:the_object) { the_class.new(sources, options) }

  describe "object" do
    subject { the_object }

    its(:upload_rate_limit) { should == 0 }
    its(:seed_ratio) { 1.5 }
    its(:seed_time) { 1440 }
    its(:connect_timeout) { 60 }
    its(:timeout) { 60 }
    its(:stop_timeout) { 0 }
    its(:destination_directory) { "." }

    its(:download_commmand) { should == "aria2c --dir=. --bt-enable-lpd --bt-min-crypto-level=arc4 --bt-require-crypto=true --enable-dht=true --enable-peer-exchange=true --max-overall-upload-limit=0 --seed-ratio=1.5 --seed-time=1440 --bt-tracker-connect-timeout=60 --bt-tracker-timeout=60 --bt-stop-timeout=0 '#{source}'" }

    context "when change upload rate limit" do
      let(:options) { {:upload_rate_limit => "5K" } }

      its(:upload_rate_limit) { should == "5K" }

      its(:download_commmand) { should == "aria2c --dir=. --bt-enable-lpd --bt-min-crypto-level=arc4 --bt-require-crypto=true --enable-dht=true --enable-peer-exchange=true --max-overall-upload-limit=5K --seed-ratio=1.5 --seed-time=1440 --bt-tracker-connect-timeout=60 --bt-tracker-timeout=60 --bt-stop-timeout=0 '#{source}'" }
    end

    context "when change seed ratio" do
      let(:options) { {:seed_ratio => 1 } }

      its(:seed_ratio) { should == 1 }

      its(:download_commmand) { should == "aria2c --dir=. --bt-enable-lpd --bt-min-crypto-level=arc4 --bt-require-crypto=true --enable-dht=true --enable-peer-exchange=true --max-overall-upload-limit=0 --seed-ratio=1 --seed-time=1440 --bt-tracker-connect-timeout=60 --bt-tracker-timeout=60 --bt-stop-timeout=0 '#{source}'" }
    end

    context "when change seed time" do
      let(:options) { {:seed_time => 2880 } }

      its(:seed_time) { should == 2880 }

      its(:download_commmand) { should == "aria2c --dir=. --bt-enable-lpd --bt-min-crypto-level=arc4 --bt-require-crypto=true --enable-dht=true --enable-peer-exchange=true --max-overall-upload-limit=0 --seed-ratio=1.5 --seed-time=2880 --bt-tracker-connect-timeout=60 --bt-tracker-timeout=60 --bt-stop-timeout=0 '#{source}'" }
    end

    context "when change connect timeout" do
      let(:options) { {:connect_timeout => 120 } }

      its(:connect_timeout) { should == 120 }

      its(:download_commmand) { should == "aria2c --dir=. --bt-enable-lpd --bt-min-crypto-level=arc4 --bt-require-crypto=true --enable-dht=true --enable-peer-exchange=true --max-overall-upload-limit=0 --seed-ratio=1.5 --seed-time=1440 --bt-tracker-connect-timeout=120 --bt-tracker-timeout=60 --bt-stop-timeout=0 '#{source}'" }
    end

    context "when change timeout" do
      let(:options) { {:timeout => 120 } }

      its(:timeout) { should == 120 }

      its(:download_commmand) { should == "aria2c --dir=. --bt-enable-lpd --bt-min-crypto-level=arc4 --bt-require-crypto=true --enable-dht=true --enable-peer-exchange=true --max-overall-upload-limit=0 --seed-ratio=1.5 --seed-time=1440 --bt-tracker-connect-timeout=60 --bt-tracker-timeout=120 --bt-stop-timeout=0 '#{source}'" }
    end

    context "when change stop timeout" do
      let(:options) { {:stop_timeout => 120 } }

      its(:stop_timeout) { should == 120 }

      its(:download_commmand) { should == "aria2c --dir=. --bt-enable-lpd --bt-min-crypto-level=arc4 --bt-require-crypto=true --enable-dht=true --enable-peer-exchange=true --max-overall-upload-limit=0 --seed-ratio=1.5 --seed-time=1440 --bt-tracker-connect-timeout=60 --bt-tracker-timeout=60 --bt-stop-timeout=120 '#{source}'" }
    end

    context "when change destination directory" do
      let(:options) { {:destination_directory => "/tmp" } }

      its(:destination_directory) { should == "/tmp" }

      its(:download_commmand) { should == "aria2c --dir=/tmp --bt-enable-lpd --bt-min-crypto-level=arc4 --bt-require-crypto=true --enable-dht=true --enable-peer-exchange=true --max-overall-upload-limit=0 --seed-ratio=1.5 --seed-time=1440 --bt-tracker-connect-timeout=60 --bt-tracker-timeout=60 --bt-stop-timeout=0 '#{source}'" }
    end

    context "when use default tor proxy" do
      let(:options) { {:use_tor_proxy => true } }

      its(:use_tor_proxy) { should == true }

      its(:download_commmand) { should == "aria2c --dir=. --bt-enable-lpd --bt-min-crypto-level=arc4 --bt-require-crypto=true --enable-dht=true --enable-peer-exchange=true --max-overall-upload-limit=0 --seed-ratio=1.5 --seed-time=1440 --bt-tracker-connect-timeout=60 --bt-tracker-timeout=60 --bt-stop-timeout=0 --all-proxy=127.0.0.1:9050 '#{source}'" }
    end

    context "when use custom tor proxy" do
      let(:options) { {:use_tor_proxy => '8.8.8.8:9050' } }

      its(:use_tor_proxy) { should == '8.8.8.8:9050' }

      its(:download_commmand) { should == "aria2c --dir=. --bt-enable-lpd --bt-min-crypto-level=arc4 --bt-require-crypto=true --enable-dht=true --enable-peer-exchange=true --max-overall-upload-limit=0 --seed-ratio=1.5 --seed-time=1440 --bt-tracker-connect-timeout=60 --bt-tracker-timeout=60 --bt-stop-timeout=0 --all-proxy=8.8.8.8:9050 '#{source}'" }
    end

    context "when have 2 sources" do
      let(:source2) { "magnet:?xt=urn:btih:source2" }
      let(:sources) { [source, source2] }

      it "TODO"
    end
  end

  describe ".download" do
    before do
      the_object.stub(:download => true)
      the_class.stub(:new => the_object)
    end
    after { the_class.download(source, options) }

    it "should create new instance" do
      the_class.should_receive(:new).with(source, options)
    end

    it "should call #download on new instance" do
      the_object.should_receive(:download)
    end
  end

  describe ".download!" do
    before do
      the_object.stub(:download! => true)
      the_class.stub(:new => the_object)
    end

    after { the_class.download!(source, options) }

    it "should create new instance" do
      the_class.should_receive(:new).with(source, options)
    end

    it "should call #download on new instance" do
      the_object.should_receive(:download!)
    end
  end

  describe "#download" do
    after { the_object.download }

    it "should run download command in system" do
      the_object.should_receive(:system).with("aria2c --dir=. --bt-enable-lpd --bt-min-crypto-level=arc4 --bt-require-crypto=true --enable-dht=true --enable-peer-exchange=true --max-overall-upload-limit=0 --seed-ratio=1.5 --seed-time=1440 --bt-tracker-connect-timeout=60 --bt-tracker-timeout=60 --bt-stop-timeout=0 '#{source}'")
    end
  end

  describe "#download!" do
    let(:download_status) { true }
    before { the_object.stub(:download => download_status) }

    it "should run download" do
      the_object.should_receive(:download).and_return(true)
      the_object.download!
    end

    context "when download failed" do
      let(:download_status) { false }

      it {
        expect {
          the_object.download!
        }.to raise_error(BitTorrent::DownloadError)
      }
    end
  end


end
