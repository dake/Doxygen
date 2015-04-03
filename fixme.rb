#!/usr/bin/env ruby

#
# v1.0
# This script helps you make fixed comments in Obj-C/C/C++ files in XCode
#
# Created by Dake 10/02/2012
# http://glade.tk
#


module Fixme

  class Documenter    
    def document(code)
      # 缩进量
      indent = base_indentation(code)
      commented_list = ""
      t = Time.now
      format="%Y-%m-%d"
      creatTime = t.strftime(format)
      creatTime.gsub!(/\n/, '')

      author = `hostname -s`
      author.gsub!(/\n/, '')

      beginFix = "#{indent}/* MARK: BEGIN: <#modified#> by #{author}, <#description#>, #{creatTime} */\n"
      endFix = "\n#{indent}/* MARK: END */"
      
      commented_list += beginFix
      commented_list += code
      commented_list += endFix

      commented_list
    end

    def base_indentation(code)
      matches = code.scan(/^(\s*)/)
      return '' if matches.size == 0
      matches[0][0].to_s
    end
  end
end


# Unicode considerations:
#  Set $KCODE to 'u'. This makes STDIN and STDOUT both act as containing UTF-8.
$KCODE = 'u'

#  Since any Ruby version before 1.9 doesn't much care for Unicode,
#  patch in a new String#utf8_length method that returns the correct length
#  for UTF-8 strings.
UNICODE_COMPETENT = ((RUBY_VERSION)[0..2].to_f > 1.8)

unless UNICODE_COMPETENT # lower than 1.9
  class String
    def utf8_length
      i = 0
      i = self.scan(/(.)/).length
      i
    end
  end
else # 1.9 and above
  class String
    alias_method :utf8_length, :length
  end
end

input = STDIN.gets nil

# input now contains the contents of STDIN.
# Write your script here. 
# Be sure to print anything you want the service to output.
documenter = Fixme::Documenter.new
replacement = documenter.document(input)
print replacement
