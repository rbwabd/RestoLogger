class Hideable < Obfuscatable
  after_initialize :init_routine
  
  self.abstract_class = true

  scope :with_visibility, lambda { |visibility| {:conditions => "visibility_mask & #{2**VISIBILITIES.index(visibility.to_s)} > 0 "} }
  # so 1 = all 2 = friends, 4 = me
  VISIBILITIES = [I18n.t('visibility_all'),I18n.t('visibility_friends'),I18n.t('visibility_me')]
  def visibilities=(visibilities)
    self.visibility_mask = (visibilities & VISIBILITIES).map { |r| 2**VISIBILITIES.index(r) }.sum
  end
  def visibilities
    VISIBILITIES.reject { |r| ((visibility_mask || 0) & 2**VISIBILITIES.index(r)).zero? }
  end
  def visibility?(visibility)
    visibilities.include? visibility.to_s
  end

  private 
    def init_routine
      #set visibility to 'all'
      self.visibility_mask = 1;
    end
end