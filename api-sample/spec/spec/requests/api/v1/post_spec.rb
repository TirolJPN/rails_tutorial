require 'rails_helper'


describe 'PostAPI' do
  # api/v1/postsに対するテスト
  it '全てのポストを取得する' do
    FactoryBot.create_list(:post, 10)

    get '/api/v1/posts'
    json = JSON.parse(response.body)

    # リクエスト成功を表す200が返ってきたか確認する。
    expect(response.status).to eq(200)

    # 正しい数のデータが返ってきたか確認する。
    expect(json['data'].length).to eq(10)
  end

  # api/v1/posts/:idに対するテスト
  it '特定のポストを取得する' do
    post = FactoryBot.create(:post, title: 'test-title')

    get "/api/v1/posts/#{post.id}"
    json = JSON.parse(response.body)

    # リクエスト成功を表す200が返ってきたか確認する
    expect(response.status).to eq(200)

    # 要求したポストのみ取得したことを確認する
    expect(json['data']['title']).to eq(post.title)
  end

  it '新しいポストを作成する' do
    valid_params = { title: 'title' }

    # データが作成されていることを確認する
    expect { post '/api/v1/posts', params: { post: valid_params} }.to change(Post, :count).by(+1)

    # リクエスト成功を表す200が返ってきたか確認する
    expect(response.status).to eq(200)
  end

  it 'ポストの編集を行う' do
    post = FactoryBot.create(:post, title: 'old-title')

    put "/api/v1/posts/#{post.id}", params: { post: { title: 'new-title' } }
    json = JSON.parse(response.body)

    # リクエスト成功を表す200が返ってきたかを確認する
    expect(response.status).to eq(200)

    # データが更新されていることを確認する
    expect(json['data']['title']).to eq('new-title')
  end

  it 'ポストの削除を行う' do
    post = FactoryBot.create(:post)

    # データが削除されていることを確認する
    expect { delete "/api/v1/posts/#{post.id}" }.to change(Post, :count).by(-1)

    # リクエスト成功を表す200が返ってきたことを確認する
    expect(response.status).to eq(200)
  end
end

