module Decentral
  module Log
    def log_counts(*args)
      log_colorful :green, *args
    end

    def log_info(*args)
      log_colorful :yellow, *args
    end

    def log(*args)
      log_colorful :blue, *args
    end

    def log_colorful(color, *args)
      args.each do |arg|
        if arg.is_a?(Array) || arg.is_a?(Hash)
          arg = JSON.pretty_generate(arg) rescue arg
        end
        output = if color
          arg.to_s.public_send color
        else
          arg
        end
        Rails.logger.info output
      end
    end

  end
end

# from colorize gem:
#
# def color_codes
#   {
#       :black   => 0, :light_black    => 60,
#       :red     => 1, :light_red      => 61,
#       :green   => 2, :light_green    => 62,
#       :yellow  => 3, :light_yellow   => 63,
#       :blue    => 4, :light_blue     => 64,
#       :magenta => 5, :light_magenta  => 65,
#       :cyan    => 6, :light_cyan     => 66,
#       :white   => 7, :light_white    => 67,
#       :default => 9
#   }
# end
#
# def mode_codes
#   {
#       :default   => 0, # Turn off all attributes
#       :bold      => 1, # Set bold mode
#       :italic    => 3, # Set italic mode
#       :underline => 4, # Set underline mode
#       :blink     => 5, # Set blink mode
#       :swap      => 7, # Exchange foreground and background colors
#       :hide      => 8  # Hide text (foreground color would be the same as background)
#   }
# end
