class HomeController < StoreController
  helper 'spree/products'
  respond_to :html

  def index
    # Fetch specific taxons as needed
    @basic_bundle_taxon = Spree::Taxon.find_by(permalink: 'categories/basic-bundle')
    @caps_taxon = Spree::Taxon.find_by(permalink: 'categories/clothing/caps')
    @searcher = build_searcher(params.merge(include_images: true))
    @products = @searcher.retrieve_products
    @taxonomies = Spree::Taxonomy.includes(root: :children)

    if @basic_bundle_taxon
      basic_bundle_searcher = build_searcher(params.merge(include_images: true, taxon: @basic_bundle_taxon.id))
      @french_tip_products = basic_bundle_searcher.retrieve_products
    else
      @french_tip_products = []
    end

    if @caps_taxon
      caps_searcher = build_searcher(params.merge(include_images: true, taxon: @caps_taxon.id))
      @caps_products = caps_searcher.retrieve_products
    else
      @caps_products = []
    end

    # Fetch all taxonomies with their root and children
    @taxonomies = Spree::Taxonomy.includes(root: :children)
    # Original Spree logic to fetch products
    @searcher = build_searcher(params.merge(include_images: true))
    @products = @searcher.retrieve_products
  end

    

  private

  def build_searcher(params)
    Spree::Config.searcher_class.new(params).tap do |searcher|
      searcher.current_user = try_spree_current_user
    end
  end
end
