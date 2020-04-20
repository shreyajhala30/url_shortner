# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UrlDatum, type: :model do
  let(:source_url) { 'https://www.facebook.com' }
  describe 'Validations' do
    it { should validate_presence_of(:source_url) }
  end

  describe 'Custom Validations' do
    it 'should create a record if source_url is an actual url' do
      before_count = UrlDatum.count
      create(:url_datum, source_url: source_url)
      expect(UrlDatum.count).not_to eq(before_count)
    end

    it 'should create a token if uniq source_url' do
      before_count = UrlDatum.count
      create(:url_datum, source_url: source_url)
      expect(UrlDatum.count).not_to eq(before_count)
    end

    it 'should fail on invalid url' do
      url = described_class.new(source_url: 'https://www.facebookkkkk.com')

      expect(url.valid?).to be(false)
      expect(url.save).to be(false)
    end
  end

  describe 'before save' do
    it 'sets the unique token' do
      url = described_class.new(source_url: source_url)

      expect(url.valid?).to be(true)
      expect(url.token).to be_falsey
      expect(url.save).to be(true)
      expect(url.token).not_to be_blank
    end

    it 'sets the sanitized_url' do
      url = described_class.new(source_url: source_url)

      expect(url.valid?).to be(true)
      expect(url.sanitized_url).to be_falsey
      expect(url.save).to be(true)
      expect(url.sanitized_url).not_to be_blank
    end
  end

  describe 'Instance Methods' do
    it '#sanitize_url' do
      url = UrlDatum.new(source_url: 'https://www.google.co.in')
      expect(url.sanitize_url).to eq('http://google.co.in')
    end
  end
end
