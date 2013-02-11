require 'liquid'
require "#{ File.dirname(__FILE__) }/liquid/drops/base_drop"
Dir.glob("#{ File.dirname(__FILE__) }/liquid/**/*.rb").each { |file| require file }

Liquid::Template.register_filter(UtilFilters)
Liquid::Template.register_filter(CoreFilters)
Liquid::Template.register_filter(DefaultPagination)
Liquid::Template.register_filter(PaginationFilters)
Liquid::Template.register_filter(UrlFilters)

Liquid::Template.register_tag(:checkoutform, CheckoutForm)
Liquid::Template.register_tag(:get, Get)
Liquid::Template.register_tag(:paginate, Paginate)

module BigCartel
  module Builder
    class Liquifier
      def initialize(theme, store, request)
        @theme = theme
        @store = store
        @request = request
      end
      
      def render(content, overridden_assigns={})
        Liquid::Template.parse(content).render(assigns.update(overridden_assigns), :registers => registers)
      end
      
      private
      
      def assigns
        {
          'errors' => [],
          'store' => AccountDrop.new(@store.account),
          'cart' => CartDrop.new,
          'theme' => ThemeDrop.new(@theme.user_settings),
          # 'page' => PageDrop.new(@page),
          # 'product' => ProductDrop.new(@product),
          'pages' => PagesDrop.new(@store.pages.map { |p| PageDrop.new(p) }),
          'categories' => CategoriesDrop.new(@store.categories.map { |c| CategoryDrop.new(c) }),
          'artists' => ArtistsDrop.new(@store.artists.map { |a| ArtistDrop.new(a) }),
          'products' => ProductsDrop.new(@store.products.map { |p| ProductDrop.new(p) }),
          'contact' => ContactDrop.new,
          'head_content' => '<meta name="generator" content="Big Cartel" />'
        }
      end

      def registers
        {
          # :params => @params,
          # :full_url => @page.full_url,
          # :path => @page.url,
          # :currency => assigns['store'].currency,
          # :settings => @settings,
          # :category => @category,
          # :artist => @artist
        }
      end
    end
  end
end