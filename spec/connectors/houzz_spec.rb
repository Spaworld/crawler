require 'rails_helper'
require 'shared_examples/a_driver'

RSpec.describe Houzz do

  let(:subject)   { Houzz.new(BillyDriver.new) }
  let(:connector) { subject }
  let(:driver)    { subject.driver }

  it_behaves_like('a driver')

  describe 'authing' do

    it 'should get access to panel' do
      connector.login
      expect(connector.logged_in?)
        .to be_truthy
    end

    it 'should see listings\' data from admin' do
      connector.login
      expect(Listing)
        .to receive(:append_houzz_url)
        .with(a_kind_of(String), a_kind_of(String))
      connector.visit_admin_panel
    end

  end

end
