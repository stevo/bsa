module CmsHelper
  def link_to_cms_page(slug)
    if (page = Cms::Page.find_by_slug(slug.to_s.dasherize))
      link_to page.label, page.full_path, target: '_blank'
    end
  end
end
