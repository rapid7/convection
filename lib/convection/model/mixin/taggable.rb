require 'json'

module Convection
  module Model
    ##
    # CloudFormation ResourceTag set
    ##
    class Tags < Hash
      def render
        map do |t|
          {
            :Key => t[0].to_s,
            :Value => t[1]
          }
        end
      end
    end

    module Mixin
      ##
      # Add tag helpers to taddable resources
      ##
      module Taggable
        def tags
          @tags ||= Tags.new
        end

        def tag(key, value)
          tags[key] = value
        end

        ## Helper for Asgard
        def immutable_metadata(purpose, target = '')
          tag('immutable_metadata', JSON.generate(
            :purpose => purpose,
            :target => target
          ))
        end

        def render_tags(resource)
          resource.tap do |r|
            r['Properties']['Tags'] = tags.render unless tags.empty?
          end
        end
      end
    end
  end
end
