require 'rails_helper'

describe Contact do

  # 性と名とメールがあれば有効な状態であること
  it "is valid with a firstname, lastname and email" do
    contact = Contact.new(
                         firstname: 'Aaron',
                         lastname: 'Sumner',
                         email: 'tester@example.com'
    )
    expect(contact).to be_valid
  end

  # 名がなければ無効な状態であること
  it "is invalid without a firstname" do
    contact = Contact.new(firstname: nil)
    contact.valid?
    expect(contact.errors[:firstname]).to include("can't be blank")
  end

  # 性がなければ無効な状態であること
  it "is invalid without a lastnam" do
    contact = Contact.new(lastname: nil)
    contact.valid?
    expect(contact.errors[:lastname]).to include("can't be blank")
  end

  # メールアドレスがなければ無効な状態であること
  it "is invalid without an email address" do
    Contact.create(
               firstname: 'Joe',
               lastname: 'Tester',
               email: 'tester@example.com'
    )
    contact = Contact.new(
                         firstname: 'Joe',
                         lastname: 'Tester',
                         email: 'tester@example.com'
    )
    expect(contact.errors[:email]).to include("has already been token")
  end

  # 重複したメールアドレスなら無効な状態であること
  it "is invalid with a duplicate email address"

  # 連絡先のフルネームを文字列として返すこと
  it "returns a contact's full name as a string"
end