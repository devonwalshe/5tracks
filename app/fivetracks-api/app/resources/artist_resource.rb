class ArtistResource < JSONAPI::Resource
  attributes :name, :realname, :profile, :group_count, :member_count, :release_count
  
  
  relationship :artist_aliases, to: :many
  relationship :groups, to: :many
  relationship :members, to: :many
  relationship :artist_urls, to: :many
  relationship :artist_name_variations, to: :many
  relationship :release_tracks, to: :many
  relationship :releases, to: :many
  relationship :labels, to: :many
  
  # Filters
  # filters :label_id
  
  filter :label_id, apply: ->(records, value, _options) {
    records.joins(:labels).where('release_label.label_id = ? and release_artist.extra = ?', value, 0).distinct
  }
  
  # def self.apply_filter(records, filter, value, options)
  #   case filter
  #   when :label_id
  #     print 'here'
  #     print records.label_id(value)
  #     records.label_id(value).artists
  #   else
  #     super(records, filter, value, options)
  #   end
  # end
  
  # Attr methods
  def group_count
    @model.groups.count
  end
  
  def member_count
    @model.members.count
  end
  
  def self.sortable_fields(context)
    super + [:'release_count', :'label_id']
  end
end