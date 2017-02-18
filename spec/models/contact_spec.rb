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

    contact.valid?
    expect(contact.errors[:email]).to include("has already been taken")
  end

  # 重複したメールアドレスなら無効な状態であること
  it "is invalid with a duplicate email address" do
    contact = Contact.create(
                         firstname: 'Joe',
                         lastname: 'Tester',
                         email: 'tester@example.com'
    )
    contact.phones.create(
                      phone_type: 'home',
                      phone: '785-555-1234'
    )
    mobile_phone = contact.phones.build(
                                     phone_type: 'mobile',
                                     phone: '785-555-1234'
    )

    mobile_phone.valid?
    expect(mobile_phone.errors[:phone]).to include('has already been taken')
  end

  # 連絡先のフルネームを文字列として返すこと
  it "returns a contact's full name as a string" do
    contact = Contact.create(
        firstname: 'Joe',
        lastname: 'Tester',
        email: 'tester@example.com'
    )
    contact.phones.create(
        phone_type: 'home',
        phone: '785-555-1234'
    )

    other_contact = Contact.new
    other_phone = other_contact.phones.build(
                                            phone_type: 'home',
                                            phone: '785-555-1234'
    )

    expect(other_phone).to be_valid
  end

  # 連絡先のフルネームを文字列として返すこと
  it "returns a contact's full name as a string" do
    contact = Contact.new(
                         firstname: 'John',
                         lastname: 'Doe',
                         email: 'tester@example.com'
    )

    expect(contact.name).to eq 'John Doe'
  end

  describe "filter last name by letter" do
    before :each do
      @smith = Contact.create(
          firstname: 'John',
          lastname: 'Smith',
          email: 'jsmith@example.com'
      )
      @jones = Contact.create(
          firstname: 'Tim',
          lastname: 'Jones',
          email: 'tjones@example.com'
      )
      @johnson = Contact.create(
          firstname: 'John',
          lastname: 'Johnson',
          email: 'jjohnson@example.com'
      )
    end
    # マッチする文字の場合
    context "matching letters" do
      # マッチした結果をソート済みの配列として返すこと
      it "returns sorted array of results that match" do
        expect(Contact.by_letter("J")).to eq [@johnson, @jones]
      end
    end

    # マッチしない文字の場合
    context "non-matching letters" do
      # マッチしなかったものは結果に含まれていないこと
      it "returns sorted array of results that match" do
        expect(Contact.by_letter("J")).not_to include @smith
      end
    end
  end
end