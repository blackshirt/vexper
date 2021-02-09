PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS `jenis` (
    `jid` INTEGER PRIMARY KEY AUTOINCREMENT,
    `nama` TEXT NOT NULL UNIQUE,
    `desc` TEXT
);

INSERT
    OR REPLACE INTO `jenis`
VALUES
    (0, "Unknown", "Unknonw jenis"),
    (1, "Barang", "Pengadaan barang"),
    (
        2,
        "Pekerjaan Konstruksi",
        "Pengadaan jasa konstruksi"
    ),
    (
        3,
        "Jasa Konsultansi",
        "Pengadaan jasa konsultansi"
    ),
    (4, "Jasa Lainnya", "Pengadaan jasa lainnya"),
    (5, "Sayembara", "Pengadaan sayembara"),
    (6, "Swakelola", "Jenis swakelola") ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS `metode` (
    `mid` INTEGER PRIMARY KEY AUTOINCREMENT,
    `nama` VARCHAR(256) NOT NULL,
    `desc` VARCHAR(256)
);

INSERT
    OR REPLACE INTO metode(mid, nama, desc)
VALUES
    (0, "Unknown", "Unknown method"),
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
        "e-Purchasing",
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
    `kode_rup` TEXT NOT NULL UNIQUE,
    `nama_paket` VARCHAR(256) NOT NULL,
    `pagu` VARCHAR(128) NOT NULL,
    `kegiatan` TEXT,
    `sumber_dana` VARCHAR(128) NOT NULL,
    `kode_satker` TEXT NOT NULL,
    `awal_pemilihan` VARCHAR(128) NOT NULL,
    `akhir_pemilihan` TEXT NOT NULL DEFAULT 'Unknown',
    `awal_pelaksanaan` TEXT NOT NULL DEFAULT 'Unknown',
    `akhir_pelaksanaan` TEXT NOT NULL DEFAULT 'Unknown',
    `awal_pemanfaatan` TEXT NOT NULL DEFAULT 'Unknown',
    `akhir_pemanfaatan` TEXT NOT NULL DEFAULT 'Unknown',
    `usaha_kecil` TEXT CHECK (`usaha_kecil` IN ('Unknown', 'Ya', 'Tidak')) NOT NULL DEFAULT 'Unknown',
    `tgl_perbaharui_paket` TEXT NOT NULL DEFAULT 'Unknown',
    `tipe_swakelola` TEXT NOT NULL DEFAULT 'Unknown',
    `tipe` TEXT NOT NULL NOT NULL DEFAULT 'Unknown',
    `metode` INT NOT NULL DEFAULT 0,
    `jenis` INT NOT NULL DEFAULT 0,
    `year` TEXT NOT NULL DEFAULT (strftime('%Y', 'now')),
    `inserted_at` TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `last_updated` TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(`kode_satker`) REFERENCES `RekapKegiatanSatker`(`kode_satker`),
    FOREIGN KEY(`metode`) REFERENCES `metode`(`mid`),
    FOREIGN KEY(`jenis`) REFERENCES `jenis`(`jid`)
);

CREATE TABLE IF NOT EXISTS `RekapKegiatanKbm` (
    `id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    `kode_kldi` TEXT NOT NULL UNIQUE,
    `nama_kldi` TEXT NOT NULL UNIQUE,
    `tot_paket_pyd` TEXT NOT NULL DEFAULT '0',
    `tot_pagu_pyd` TEXT NOT NULL DEFAULT '0',
    `tot_paket_swa` TEXT NOT NULL DEFAULT '0',
    `tot_pagu_swa` TEXT NOT NULL DEFAULT '0',
    `tot_paket_pds` TEXT NOT NULL DEFAULT '0',
    `tot_pagu_pds` TEXT NOT NULL DEFAULT '0',
    `tot_paket` TEXT NOT NULL DEFAULT '0',
    `tot_pagu` TEXT NOT NULL DEFAULT '0',
    `tipe_kldi` TEXT NOT NULL DEFAULT 'KABUPATEN',
    `inserted_at` TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `last_updated` TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `year` TEXT NOT NULL DEFAULT (strftime('%Y', 'now'))
);

CREATE TABLE IF NOT EXISTS `RekapKegiatanSatker` (
    `id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    `kode_satker` TEXT NOT NULL UNIQUE,
    `nama_satker` TEXT NOT NULL UNIQUE,
    `tot_pyd` TEXT NOT NULL DEFAULT '0',
    `tot_pagu_pyd` TEXT NOT NULL DEFAULT '0',
    `tot_swa` TEXT NOT NULL DEFAULT '0',
    `tot_pagu_swa` TEXT NOT NULL DEFAULT '0',
    `tot_pds` TEXT NOT NULL DEFAULT '0',
    `tot_pagu_pds` TEXT NOT NULL DEFAULT '0',
    `inserted_at` TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `last_updated` TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `year` TEXT NOT NULL DEFAULT (strftime('%Y', 'now'))
);

CREATE TABLE IF NOT EXISTS `RekapAnggaranKbm`(
    `id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    `kode_kldi` TEXT NOT NULL UNIQUE,
    `nama_kldi` TEXT NOT NULL UNIQUE,
    `tot_anggaran_pyd` TEXT NOT NULL DEFAULT '0',
    `tot_anggaran_swa` TEXT NOT NULL DEFAULT '0',
    `tot_anggaran_pds` TEXT NOT NULL DEFAULT '0',
    `tot_anggaran_semua` TEXT NOT NULL DEFAULT '0',
    `inserted_at` TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `last_updated` TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `year` TEXT NOT NULL DEFAULT (strftime('%Y', 'now'))
);

CREATE TABLE IF NOT EXISTS `RekapAnggaranSatker`(
    `id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    `kode_satker` TEXT NOT NULL UNIQUE,
    `nama_satker` TEXT NOT NULL UNIQUE,
    `tot_anggaran_pyd_satker` TEXT NOT NULL DEFAULT '0',
    `tot_anggaran_swa_satker` TEXT NOT NULL DEFAULT '0',
    `tot_anggaran_pds_satker` TEXT NOT NULL DEFAULT '0',
    `tot_anggaran_satker` TEXT NOT NULL DEFAULT '0',
    `inserted_at` TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `last_updated` TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `year` TEXT NOT NULL DEFAULT (strftime('%Y', 'now'))
);

CREATE VIEW IF NOT EXISTS `v_rups` AS
SELECT
    Rup.kode_rup AS kode_rup,
    Rup.nama_paket AS nama_paket,
    Rup.sumber_dana AS sumber_dana,
    Rup.pagu AS pagu,
    RekapKegiatanSatker.nama_satker AS nama_satker,
    RekapKegiatanSatker.kode_satker AS kode_satker,
    Rup.jenis AS jenis,
    Rup.metode AS metode,
    Rup.awal_pemilihan AS awal_pemilihan,
    Rup.akhir_pemilihan AS akhir_pemilihan,
    Rup.awal_pelaksanaan AS awal_pelaksanaan,
    Rup.akhir_pelaksanaan AS akhir_pelaksanaan,
    Rup.tipe AS tipe,
    Rup.kegiatan AS kegiatan,
    Rup.usaha_kecil AS usaha_kecil,
    Rup.year AS tahun,
    Rup.last_updated AS last_updated
FROM
    `Rup`
    INNER JOIN RekapKegiatanSatker ON RekapKegiatanSatker.kode_satker = Rup.kode_satker;

/*
 INNER JOIN metode on metode.mid = Rup.metode
 INNER JOIN jenis ON jenis.jid = Rup.jenis;
 */
CREATE VIEW IF NOT EXISTS `v_all_satker` AS
SELECT
    kode_satker,
    nama_satker
FROM
    `RekapKegiatanSatker`;

CREATE VIEW IF NOT EXISTS `v_stat_paket_by_tipe_n_metode` AS
select
    tipe,
    metode,
    count(*) as total_paket,
    sum(count(*)) over() as total_seluruh_paket,
    round(100.0 * count(*) / sum(count(*)) over(), 2) as percent_paket
from
    v_rups
group by
    metode,
    tipe;

CREATE VIEW IF NOT EXISTS `v_stat_pagu_by_tipe_n_metode` AS
select
    tipe,
    metode,
    sum(pagu) as total_pagu,
    sum(sum(pagu)) over() as total_seluruh_pagu,
    round(100.0 * sum(pagu) / sum(sum(pagu)) over(), 2) as percent_pagu
from
    v_rups
group by
    metode,
    tipe