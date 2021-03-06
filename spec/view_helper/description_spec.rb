require 'spec_helper'

describe MetaTags::ViewHelper, 'displaying description' do
  subject { ActionView::Base.new }

  it 'should not display description if blank' do
    subject.description('')
    expect(subject.display_meta_tags).to eq('')
  end

  it 'should display description when "description" used' do
    subject.description('someDescription')
    subject.display_meta_tags(site: 'someSite').tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "someDescription", name: "description" })
    end
  end

  it 'should display description when "set_meta_tags" used' do
    subject.set_meta_tags(description: 'someDescription')
    subject.display_meta_tags(site: 'someSite').tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "someDescription", name: "description" })
    end
  end

  it 'should display default description' do
    subject.display_meta_tags(site: 'someSite', description: 'someDescription').tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "someDescription", name: "description" })
    end
  end

  it 'should use custom description if given' do
    subject.description('someDescription')
    subject.display_meta_tags(site: 'someSite', description: 'defaultDescription').tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "someDescription", name: "description" })
    end
  end

  it 'should strip multiple spaces' do
    subject.display_meta_tags(site: 'someSite', description: "some \n\r\t description").tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "some description", name: "description" })
    end
  end

  it 'should strip HTML' do
    subject.display_meta_tags(site: 'someSite', description: "<p>some <b>description</b></p>").tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "some description", name: "description" })
    end
  end

  it 'should escape double quotes' do
    subject.display_meta_tags(description: 'some "description"').tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "some \"description\"", name: "description" })
    end
  end

  it 'should escape ampersands properly' do
    subject.display_meta_tags(description: 'verify & commit').tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "verify & commit", name: "description" })
    end
  end

  it 'should truncate correctly' do
    subject.display_meta_tags(site: 'someSite', description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam dolor lorem, lobortis quis faucibus id, tristique at lorem. Nullam sit amet mollis libero. Morbi ut sem malesuada massa faucibus vestibulum non sed quam. Duis quis consectetur lacus. Donec vitae nunc risus. Sed placerat semper elit, sit amet tristique dolor. Maecenas hendrerit volutpat.").tap do |meta|
      expect(meta).to have_tag('meta', with: { content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam dolor lorem, lobortis quis faucibus id, tristique at lorem. Nullam sit amet mollis libero. Morbi ut sem malesuada massa faucibus vestibulum non sed quam. Duis quis consectetur lacus. Donec vitae nunc risus. Sed placerat semper elit, sit", name: "description" })
    end
  end
end
