module PostHelper
  ALLOWED_TAGS = Rails::Html::WhiteListSanitizer.allowed_tags - %w(img a)

  def post_summary_html(post)
    if post.summary.present?
      content_tag :p, post.summary
    else
      html = Rails::Html::WhiteListSanitizer.new.sanitize(post_content_html(post), allowed_tags: ALLOWED_TAGS)
      doc = Nokogiri::HTML.fragment(html)
      para = doc.search('p').detect { |p| p.text.present? }
      para.try(:to_html).try(:html_safe)
    end
  end

  def post_content_html(post)
    Postmarkdown::MarkdownRenderer.new.render(render(:inline => post.content)).html_safe
  end
end
