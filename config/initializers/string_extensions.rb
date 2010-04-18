require 'iconv'

module StringExtensions

  module InstanceMethods
    
    def nicename
      Iconv.conv("ASCII//IGNORE//TRANSLIT", "UTF8", gsub(/\s+/, "-")).gsub(/[^\w-]/, '').downcase
    end
    
  end
  
end

String.send :include, StringExtensions::InstanceMethods