module Setting
  class << self
    def config
      construct = {
        is_keep_pos_balance: false
      }
      keys = construct.keys.map(&:to_s)
      data = JSON.parse($redis.get("#{ENV['DATABASE_NAME']}_global_setting")) rescue {}
      construct.stringify_keys.merge(data).slice(*keys)
    end

    def bulk_set data
      return if data.blank?  
      $redis.set "#{ENV['DATABASE_NAME']}_global_setting", data.to_json
    end

    def get key
      config[key.to_s]
    end

    def set k, v
      return if k.blank?
      old_config = config
      old_config[k.to_s] = v
      $redis.set "#{ENV['DATABASE_NAME']}_global_setting", old_config.to_json
    end
  end
end