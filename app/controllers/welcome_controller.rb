require 'redcarpet'

class WelcomeController < ApplicationController
  def about
    TodayBirthdayWorker.perform_async()

    md_filename = File.join(Rails.public_path, 'about.md')
    content = File.read md_filename

    renderer = Redcarpet::Render::HTML.new(render_options = {})
    markdown = Redcarpet::Markdown.new(renderer, extensions = {})
    @html_content = markdown.render(content)
  end
end
