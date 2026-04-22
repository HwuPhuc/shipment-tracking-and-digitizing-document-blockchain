# shipment-tracking-and-digitizing-document-blockchain
  
Để compile smart contract, mở Terminal lên và nhập lệnh sau: ``npx hardhat compile``  
  
Bước 1: Để khởi chạy dự án, mở 1 cửa sổ Terminal và chạy lệnh ``npx hardhat node``, kết quả sẽ trả về 20 address + private key  
Bước 2: Tiếp tục mở cửa sổ Terminal thứ 2 (không tắt cửa sổ 1), chạy lệnh ``npx hardhat run scripts/deploy-and-test.js --network localhost``để chạy thử contract, nếu thấy chạy thử thành công (6 bước thực hiện trơn tru, địa chỉ contract được trả về, 6 tài khoản với 6 participant khác nhau)  
Bước 3: Sử dụng extension Live Server trong VS Code để chạy file index.html trong folder frontend  
Bước 4: Cài đặt extension MetaMask trên Google và mở extension lên  
Bước 5: Ở góc trên, chọn biểu tượng danh mục, và chọn Add a custom network, điền thông tin như sau và thêm network  
     Network Name = Hardhat Local  
     New RPC URL = http://127.0.0.1:8545  
     Chain ID =  31337  
     Currency Symbol = ETH  
Bước 6: Quay lại trang chủ của MetaMask, chọn biểu tượng tài khoản -> Import Account, chọn Private Key và dán các Private Key tương ứng 
với 6 tài khoản của 6 participant khác nhau đã tạo ở trên (ở cửa sổ Terminal thứ 2)  
Bước 7: Sau khi import xong tài khoản, quay lại trang web (mở bằng Live Server ở các bước trên), chọn mục Kết nối và điền địa chỉ contract (cửa sổ 2 Terminal), sau đó lần lượt bấm kết nối MetaMask và kết nối Contract  
