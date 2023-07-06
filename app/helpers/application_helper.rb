module ApplicationHelper
  def og_meta_tags
    settings.og_meta_tags_html
  end

  def settings
    Settings
  end
end
