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
  
  # Attr methods
  def group_count
    @model.groups.count
  end
  
  def member_count
    @model.members.count
  end
  
  def self.sortable_fields(context)
    super + [:'release_count']
  end
end