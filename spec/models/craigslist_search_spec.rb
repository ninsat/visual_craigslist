require 'spec_helper'

describe CraigslistSearch do

  it 'searches' do
    CraigslistSearch.query(:text => '', :min => 400, :max => 1500) 
  end

end
