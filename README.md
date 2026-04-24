# shipment-tracking-and-digitizing-document-blockchain
  
Project này là 1 project nhỏ được tạo ra với mục đích chính là học tập trong môn Công nghệ Blockchain cũng như hiểu thêm về luồng hoạt động của một hệ thống Logistics ở mức cơ bản  

## Setup

Trước khi chạy dự án này, có một vài thứ cần phải chuẩn bị trước:  

- Tải node.js tại [Trang chủ của Node.js](https://nodejs.org/en/download) (Ở thời điểm chỉnh sửa file này, node.js version dùng để chạy dự án là v.24.14.0)  
- Setup Pinata để có thể tải chứng từ lên đó, vào [trang chủ của Pinata](https://pinata.cloud/ipfs), tạo một tài khoản và đăng nhập vào Pinata, ở trang chủ, chuyển sang mục API Keys và chọn New key, đặt tên và điều chỉnh quyền như sau:  
      V3 Resources -> File (Write)  
      Legacy Endpoints -> Pinning -> pinFileToIPFS (check)  
      Legacy Endpoints -> Pinning -> pinJSONToIPFS (check)  
      Các quyền khác giữ nguyên  
- Sau khi tạo key thành công, lưu key lại, bao gồm 3 key (API key, API secret và JWT access token). Lấy JWT access token và sao chép vào thế chỗ cho phần `<JWT_ACCESS_TOKEN>` ở dòng 457 của file `frontend/index.html`  

## Run project

Để compile smart contract, mở Terminal lên và nhập lệnh sau: ``npx hardhat compile``  
  
Bước 1: Để khởi chạy dự án, mở 1 cửa sổ Terminal và chạy lệnh dưới, kết quả sẽ trả về 20 address + private key  
```terminal/shell
npx hardhet node
```

Bước 2: Tiếp tục mở cửa sổ Terminal thứ 2 (không tắt cửa sổ 1), chạy lệnh dưới để chạy thử contract, nếu thấy chạy thử thành công (6 bước thực hiện trơn tru, địa chỉ contract được trả về, 6 tài khoản với 6 participant khác nhau)  
```terminal/shell
npx hardhat run scripts/deploy-and-test.js --network localhost
```
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
