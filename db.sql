PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS `RekapKegiatanSatker` (
    `id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    `kode` TEXT NOT NULL,
    `nama` TEXT NOT NULL,
    `tot_pyd` TEXT NOT NULL DEFAULT '0',
    `tot_pagu_pyd` TEXT NOT NULL DEFAULT '0',
    `tot_swa` TEXT NOT NULL DEFAULT '0',
    `tot_pagu_swa` TEXT NOT NULL DEFAULT '0',
    `tot_pds` TEXT NOT NULL DEFAULT '0',
    `tot_pagu_pds` TEXT NOT NULL DEFAULT '0',
    `last_updated` TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `year` TEXT NOT NULL,
    UNIQUE (`kode`, `nama`)
);

CREATE TABLE IF NOT EXISTS `jenis` (
    `jid` INTEGER PRIMARY KEY AUTOINCREMENT,
    `nama` TEXT NOT NULL UNIQUE,
    `desc` TEXT
);

INSERT
    OR REPLACE INTO `jenis`
VALUES
    (1, "Barang", "Pengadaan barang"),
    (2, "Konstruksi", "Pengadaan jasa konstruksi"),
    (3, "Konsultansi", "Pengadaan jasa konsultansi"),
    (4, "Jasa Lainnya", "Pengadaan jasa lainnya"),
    (5, "Sayembara", "Pengadaan sayembara") ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS `metode` (
    `mid` INTEGER PRIMARY KEY AUTOINCREMENT,
    `nama` VARCHAR(256) NOT NULL,
    `desc` VARCHAR(256)
);

INSERT
    OR REPLACE INTO metode(mid, nama, desc)
VALUES
    (
        1,
        "Pengadaan Langsung",
        "metode pengadaan langsung"
    ),
    (2, "Tender", "metode tender umum"),
    (
        3,
        "Tender Cepat",
        "Metode tender cepat"
    ),
    (
        4,
        "E-Purchasing",
        "e-Purchasing aka e-catalog"
    ),
    (
        5,
        "Penunjukan Langsung",
        "metode penunjukkan langsung"
    ),
    (
        6,
        "Pengadaan Darurat",
        "Pengadaan dalam keadaan darurat"
    ),
    (
        7,
        "Dikecualikan",
        "pengadaan dengan metode yang dikecualikan"
    ),
    (8, "Swakelola", "Kegiatan swakelola") ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS `Rup` (
    `id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    `kode` TEXT NOT NULL UNIQUE,
    `nama_paket` VARCHAR(256) NOT NULL,
    `pagu` VARCHAR(128) NOT NULL,
    `awal_pemilihan` VARCHAR(128) NOT NULL,
    `metode` VARCHAR(128) NOT NULL,
    `sumber_dana` VARCHAR(128) NOT NULL,
    `kegiatan` TEXT,
    `satker` TEXT NOT NULL,
    `tipe` TEXT NOT NULL,
    `mtd` INT,
    `jenis` INT,
    `year` TEXT NOT NULL,
    `last_updated` TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(`satker`) REFERENCES `RekapKegiatanSatker`(`kode`),
    FOREIGN KEY(`mtd`) REFERENCES `metode`(`mid`),
    FOREIGN KEY(`jenis`) REFERENCES `jenis`(`jid`));

CREATE VIEW IF NOT EXISTS `v_rups` AS
SELECT
    Rup.id AS id,
    Rup.kode AS kode,
    Rup.nama_paket AS nama,
    Rup.sumber_dana AS dana,
    Rup.pagu AS pagu,
    Rup.awal_pemilihan AS awal_pemilihan,
    RekapKegiatanSatker.nama AS satker
FROM
    `Rup`
INNER JOIN RekapKegiatanSatker ON RekapKegiatanSatker.kode = Rup.satker;