
// scripts/deploy-and-test.js
import hre from "hardhat";

async function main() {
    const { viem } = await hre.network.connect();

    const [admin, shipper, forwarder, carrier, customs, consignee] =
        await viem.getWalletClients();

    console.log("========== LOGISTICS SYSTEM TEST ==========");
    console.log("Admin:     ", admin.account.address);
    console.log("Shipper:   ", shipper.account.address);
    console.log("Forwarder: ", forwarder.account.address);
    console.log("Carrier:   ", carrier.account.address);
    console.log("Customs:   ", customs.account.address);
    console.log("Consignee: ", consignee.account.address);

    // ===== BƯỚC 1: DEPLOY =====
    console.log("\n[BUOC 1] Deploy contract...");
    const contract = await viem.deployContract("Logistics");
    console.log("Contract deployed tại:", contract.address);

    // ===== BƯỚC 2: ADD PARTICIPANTS =====
    console.log("\n[BUOC 2] Add participants...");

    await contract.write.addParticipant(
        [shipper.account.address, "Shipper A", 1],
        { account: admin.account }
    );

    await contract.write.addParticipant(
        [forwarder.account.address, "Forwarder B", 2],
        { account: admin.account }
    );

    await contract.write.addParticipant(
        [carrier.account.address, "Carrier C", 3],
        { account: admin.account }
    );

    await contract.write.addParticipant(
        [customs.account.address, "Customs VN", 4],
        { account: admin.account }
    );

    await contract.write.addParticipant(
        [consignee.account.address, "Consignee D", 5],
        { account: admin.account }
    );

    console.log("Đã thêm participants!");

    // ===== BƯỚC 3: CREATE SHIPMENT =====
    console.log("\n[BUOC 3] Shipper tạo shipment...");
    await contract.write.createShipment(
        [consignee.account.address],
        { account: shipper.account }
    );
    console.log("Shipment ID: 1 - Created");

    // ===== BƯỚC 4: UPLOAD DOCUMENT =====
    console.log("\n[BUOC 4] Upload document...");
    await contract.write.uploadDocument(
        [1n, "Invoice", "QmABC123"],
        { account: shipper.account }
    );
    console.log("Đã upload Invoice");

    // ===== BƯỚC 5: CUSTOMS APPROVE =====
    console.log("\n[BUOC 5] Customs approve document...");
    await contract.write.approveDocument(
        [1n],
        { account: customs.account }
    );
    console.log("Document đã được duyệt");

    // ===== BƯỚC 6: UPDATE STATE =====
    console.log("\n[BUOC 6] Update trạng thái...");

    await contract.write.updateState([1n, 1], { account: shipper.account }); // Packed
    console.log("→ Packed");

    await contract.write.updateState([1n, 2], { account: forwarder.account }); // PickedUp
    console.log("→ PickedUp");

    await contract.write.updateState([1n, 5], { account: carrier.account }); // InTransit
    console.log("→ InTransit");

    await contract.write.updateState([1n, 7], { account: customs.account }); // ImportCleared
    console.log("→ ImportCleared");

    await contract.write.updateState([1n, 8], { account: consignee.account }); // Delivered
    console.log("→ Delivered");

    console.log("\nHOÀN THÀNH - FLOW LOGISTICS OK!");
}

main()
    .then(() => process.exit(0))
    .catch((err) => {
        console.error(err);
        process.exit(1);
    });
