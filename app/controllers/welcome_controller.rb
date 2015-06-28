require 'redcarpet'

class WelcomeController < ApplicationController
  def about
    render_markdown 'about.md'
  end

  def support
    render_markdown 'support.md'
  end

  def render_markdown md_filename
    md_filename = File.join(Rails.public_path, md_filename)
    content = File.read md_filename

    markdown = Redcarpet::Markdown.new(
      Redcarpet::Render::HTML,
      strikethrough: true,
    )
    @html_content = markdown.render(content)
  end
end
