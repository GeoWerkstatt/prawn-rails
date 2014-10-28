require "prawn-rails/document"
require "prawn-rails/prawn_rails_helper"

module PrawnRails
  class Renderer
    def self.call(template)
      ::Prawn::Document.extensions << PrawnRailsHelper
      new.call(template)
    end

    def call(template)
      %Q(
      if @filename
        headers["Content-Disposition"] = "attachment; filename=" + @filename + ".pdf"
      else
        headers["Content-Disposition"] = "attachment;"
      end

      pdf = PrawnRails::Document.new(PrawnRails.config.marshal_dump)

      # inline the sourcecode of the template
      #{template.source}

      self.output_buffer = pdf.render
      )
    end
  end
end
