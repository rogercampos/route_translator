require 'action_dispatch'

module ActionDispatch
  module Routing
    class RouteSet
      def add_localized_route(scope, path, options)
        saved_ops = options.dup

        RouteTranslator::Translator.translations_for(self, scope, path, options) do |*translated_args|
          add_route(*translated_args)
        end

        as = saved_ops.delete(:as)
        app, conditions, requirements, defaults, as, anchor = ActionDispatch::Routing::Mapper::Mapping.build(scope, self, path, as, saved_ops).to_route

        if RouteTranslator.config.generate_unnamed_unlocalized_routes
          add_route app, conditions, requirements, defaults, nil, anchor
        elsif RouteTranslator.config.generate_unlocalized_routes
          add_route app, conditions, requirements, defaults, as, anchor
        end
      end
    end
  end
end
