class LabelResource < JSONAPI::Resource
  attributes :name, :contact_info, :profile, :parent_name, :release_count
  
  # Relationships
  relationship :parent, to: :one
  relationship :sublabels, to: :many
  relationship :release_tracks, to: :many
  relationship :label_urls, to: :many
  relationship :releases, to: :many
  relationship :artists, to: :many
  
  def release_count
    @model.releases.count
  end
  
  def self.sortable_fields(context)
    super + [:'artists.release_count']
  end
end
