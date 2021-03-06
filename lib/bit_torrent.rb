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
    :use_tor_proxy => false,
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
        tor_proxy_options,
        sources.map { |s| "'#{s}'" }
      ].flatten.compact.join(' ')
    end

    def tor_proxy_options
      if use_tor_proxy
        if use_tor_proxy.is_a?(String)
          "--all-proxy=#{use_tor_proxy}"
        else
          '--all-proxy=127.0.0.1:9050'
        end
      end
    end

end
