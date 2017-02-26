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
    contact = build(:contact, firstname: nil)
    contact.valid?
    expect(contact.errors[:firstname]).to include("can't be blank")
  end

  # 性がなければ無効な状態であること
  it "is invalid without a lastnam" do
    contact = build(:contact, lastname: nil)
    contact.valid?
    expect(contact.errors[:lastname]).to include("can't be blank")
  end

  # メールアドレスがなければ無効な状態であること
  it "is invalid without an email address" do
    contact = build(:contact, email: nil)
    contact.valid?
    expect(contact.errors[:email]).to include("can't be blank")
  end

  # 重複したメールアドレスなら無効な状態であること
  it "is invalid with a duplicate email address" do
    create(:contact, email: "aaron@example.com")
    contact = build(:contact, email: "aaron@example.com")
    contact.valid?
    expect(contact.errors[:email]).to include("has already been taken")
  end

  # 連絡先ごとに重複した電話番號を許可しないこと
  it "does not allow duplicate phone numbers per contact" do
    contact = create(:contact)
    create(:home_phone, contact: contact, phone: '785-555-1234')
    mobile_phone = build(:mobile_phone, contact: contact, phone: '785-555-1234')

    mobile_phone.valid?
    expect(mobile_phone.errors[:phone]).to include("has already been taken")
  end

  # 2件の連絡先で同じ電話番號を共有できること
  it "allows tow contacts to share a phone number" do
    create(:home_phone, phone_type: 'home', phone: '785-555-1234')
    expect(build(:home_phone, phone: '785-555-1234')).to be_valid
  end

  # 連絡先のフルネームを文字列として返すこと
  it "returns a contact's full name as a string" do
    contact = build(:contact, firstname: "Jane", lastname: "Smith")
    expect(contact.name).to eq 'Jane Smith'
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

  # 有効なファクトリを持つこと
  it "has a valid factory" do
    expect(build(:contact)).to be_valid
  end

  # 3つの電話番號を持つこと
  it "has three phone numbers" do
    expect(create(:contact).phones.count).to eq 3
  end
end