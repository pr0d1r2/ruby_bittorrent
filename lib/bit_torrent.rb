class BitTorrent

  class DownloadError < StandardError
  end

  DEFAULTS = {
    :upload_rate_limit => 0,
    :seed_ratio => 1.5,
    :seed_time => 1440, # minutes
    :connect_timeout => 60,
    :timeout => 60,
    :stop_timeout => 0,
    :destination_directory => "."
  }

  attr :sources
  attr *DEFAULTS.keys

  def initialize(source, options = {})
    @sources = [ source ].flatten
    DEFAULTS.keys.each do |option|
      self.instance_variable_set("@#{option}", (options[option] || DEFAULTS[option]))
    end
  end

  def self.download(sources, options = {})
    new(sources, options).download
  end

  def self.download!(sources, options = {})
    new(sources, options).download!
  end

  def download
    system(download_commmand)
  end

  def download!
    download or raise DownloadError
  end

  private

    def download_commmand
      [
        'aria2c',
        "--dir=#{destination_directory}",
        '--bt-enable-lpd',
        '--bt-min-crypto-level=arc4',
        '--bt-require-crypto=true',
        '--enable-dht=true',
        '--enable-peer-exchange=true',
        "--max-overall-upload-limit=#{upload_rate_limit}",
        "--seed-ratio=#{seed_ratio}",
        "--seed-time=#{seed_time}",
        "--bt-tracker-connect-timeout=#{connect_timeout}",
        "--bt-tracker-timeout=#{timeout}",
        "--bt-stop-timeout=#{stop_timeout}",
        sources.map { |s| "'#{s}'" }
      ].flatten.join(' ')
    end

end
