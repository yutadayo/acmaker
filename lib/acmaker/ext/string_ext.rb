module Acmaker::Ext
  module StringExt
    module ClassMethods
      def colorize=(value)
        @colorize = value
      end

      def colorize
        @colorize
      end
    end # ClassMethods

    Term::ANSIColor::Attribute.named_attributes.each do |attribute|
      class_eval(<<-EOS, __FILE__, __LINE__ + 1)
        def #{attribute.name}
          if String.colorize
            Term::ANSIColor.send(#{attribute.name.inspect}, self)
          else
            self
          end
        end
      EOS
    end
  end
end

String.include(Acmaker::Ext::StringExt)
String.extend(Acmaker::Ext::StringExt::ClassMethods)
