require "test_helper" 
# test_helper untuk load framework Minitest dan fixtures

class NicknamesControllerTest < ActionDispatch::IntegrationTest
  fixtures :all
  # Memuat semua fixtures untuk pengujian

  test "Masuk room apabila sudah memiliki Nickname" do
    # Simulasikan login
    post nickname_path, params: { nickname: "Rizqi" }

    # Akses halaman new nickname
    get new_nickname_path
    assert_redirected_to rooms_path
  end

  test "membuat Nickname dan menyimpan pada session" do
    post nickname_path, params: { nickname: "TamaGo" }
    assert_redirected_to rooms_path

    follow_redirect!
    assert_equal "TamaGo", session[:nickname]
    assert session[:nickname_color].present?
  end

  test "percobaan jika Nickname kosong" do
    post nickname_path, params: { nickname: "" }
    assert_redirected_to new_nickname_path
    assert_equal "Nickname tidak boleh kosong.", flash[:alert]
  end

  test "menghapus session Nickname" do
    # Login dulu
    post nickname_path, params: { nickname: "Rizqi" }
    delete nickname_path

    assert_redirected_to new_nickname_path
    follow_redirect!
    assert_nil session[:nickname]
    assert_nil session[:nickname_color]
    assert_equal "Kamu telah keluar dari chat.", flash[:notice]
  end
end
