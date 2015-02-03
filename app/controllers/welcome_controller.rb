require 'redcarpet'

class WelcomeController < ApplicationController
  def about
    render_markdown 'about.md'
  end

  def dev_history
    render_markdown 'dev_history.md'
  end

  def render_markdown md_filename
    md_filename = File.join(Rails.public_path, md_filename)
    content = File.read md_filename

    renderer = Redcarpet::Render::HTML.new(render_options = {})
    markdown = Redcarpet::Markdown.new(renderer, extensions = {})
    @html_content = markdown.render(content)
  end
end
