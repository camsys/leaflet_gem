module LeafletHelper

  # Defaults
  MAPID = "map"
  MINZOOM = 0
  MAXZOOM = 18
  TILE_PROVIDER = 'GOOGLEMAP'
  TILE_STYLE_ID = 997

  def LeafletMap(options)
    options_with_indifferent_access = options.with_indifferent_access

    js_dependencies = Array.new
    #js_dependencies << 'http://cdn.leafletjs.com/leaflet-0.4/leaflet.js'
    #js_dependencies << 'leafletmap.js_x'
    #js_dependencies << 'leafletmap_icons.js_x'

    render :partial => '/leaflet/leaflet', :locals  => { :options => options_with_indifferent_access, :js_dependencies => js_dependencies }

  end
  # Generates the Leaflet JS code to create the map from the options hash
  # passed in via the LeafletMap helper method
  def generate_map(options)
    js = []
    # Add any icon definitions
    js << options[:icons] unless options[:icons].nil?
    # init the map with the mapid, use default if not set
    mapid = options[:mapid] ? options[:mapid] : MAPID
    min_zoom = options[:min_zoom] ? options[:min_zoom] : MINZOOM
    max_zoom = options[:max_zoom] ? options[:max_zoom] : MAXZOOM
    tile_provider = options[:tile_provider] ? options[:tile_provider] : TILE_PROVIDER
    tile_style_id = options[:tile_style_id] ? options[:tile_style_id] : TILE_STYLE_ID
    mapopts = {
      :min_zoom => min_zoom,
      :max_zoom => max_zoom,
      :tile_provider => tile_provider,
      :tile_style_id => tile_style_id
    }.to_json
    js << "leaflet_tools.init('#{mapid}', #{mapopts});"

    # add any markers
    js << "leaflet_tools.add_markers(#{options[:markers]});" unless options[:markers].nil?
    # add any circles
    js << "leaflet_tools.add_circles(#{options[:circles]});" unless options[:circles].nil?
    # add any polylines
    js << "leaflet_tools.add_polylines(#{options[:polylines]});" unless options[:polylines].nil?
    # set the map bounds
    map_bounds = SystemConfig.instance.map_bounds

    js << "leaflet_tools.set_map_bounds(#{map_bounds[0][0]},#{map_bounds[0][1]},#{map_bounds[1][0]},#{map_bounds[1][1]});"
    js << "leaflet_tools.show_map();"
    js * ("\n")
  end
end
