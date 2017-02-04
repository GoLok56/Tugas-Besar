program Aplikasi_Sistem_Informasi_Pembelian_Obat_Apotik;
{I.S. : User memasukkan data obat }
{F.S. : Menampilkan data obat yang sudah terurut berdasarkan kode }

{
  Library crt/wincrt digunakan untuk melakukan perintah-perintah konsol pada window
  dan Library SysUtils digunakan untuk mengecek ada atau tidaknya file dengan procedure
  FileExists
}
uses
    crt, SysUtils;

{
  MaksData digunakan sebagai jumlah maksimal dari data transaksi
}
const
    MaksData = 100;

{
  DataTransaksi merupakan tipe data bentukan untuk menyimpan record Transaksi
  sementara sebelum dimasukkan kedalam file.
  User merupakan tipe data bentukan array 1 dimensi untuk menyimpan username, dan
  password sementara sebelum dimasukkan kedalam file.
  ArrTransaksi merupakan tipe data bentukan untuk menyimpan array of record sementara
  untuk ditampilkan secara terurut
}
type
    DataTransaksi = record
        NoFaktur, NamaObat, TanggalTransaksi : string;
        Jumlah, Harga                        : integer;
    end;
    User          = array [1..2] of string;
    ArrTransaksi  = array [1..MaksData] of DataTransaksi;
    FileTransaksi = file of DataTransaksi;
    FileAdmin     = file of User;

var
   FileTrsk          : FileTransaksi;
   FileAdm           : FileAdmin;
   N, Menu           : integer;
   Usrnm, Pswd       : string; //Usrnm = Nama Pengguna, Pswd = Kata Sandi
   NamaObat, Tanggal : string;

procedure BuatUser(var FileAdm : FileAdmin);
{I.S. : User memasukkan jumlah user }
{F.S. : Menghasilkan file yang berisi Nama Pengguna dan Kata Sandi user }

{
  Jumlah user digunakan untuk menampung berapa banyak user yang ingin dijadikan
  admin.
  i digunakan untuk iterasi/perulangan for.
  Array UserTemp digunakan sebagai penyimpanan sementara dimana kolom satu
  sebagai username dan kolom dua sebagai password
}
var
    JumlahUser, i : integer;
    UserTemp      : User;
begin
    {
      Rewrite digunakan untuk membuka suatu file dan menghapus seluruh isinya
      dan menulis ulang secara total
    }
    rewrite(FileAdm);
    gotoxy(13,12);textcolor(4);
    write('USER BELUM DITEMUKAN, TEKAN ENTER UNTUK MENDAFTARKAN USER!');
    readln;clrscr;textcolor(7);

    {
      Algoritma untuk memasukkan berapa jumlah user yang ingin dijadikan admin
      beserta validasinya
    }
    write('Masukkan jumlah user : ');readln(JumlahUser);
    while(JumlahUser < 0) or (JumlahUser > 10) do
    begin
        textcolor(4);
        write('JUMLAH USER ANTARA 1-10!');readln;
        textcolor(7);
        gotoxy(1,2);clreol;
        gotoxy(24,1);clreol;readln(JumlahUser);
    end;

    {
      Algoritma untuk meminta masukkan user dan menyimpannya kedalam file dalam
      bentuk tabel.
    }
    clrscr;
    writeln('             DAFTAR USER             ');
    writeln('             ===========             ');
    writeln('-------------------------------------');
    writeln('|         Nama         |  Password  |');
    writeln('-------------------------------------');
    for i := 1 to JumlahUser do
    begin
        writeln('|                      |            |');

        { UserTemp[1] merupakan username, UserTemp[2] merupakan password }
        gotoxy(3,i+5);readln(UserTemp[1]);
        gotoxy(26,i+5);readln(UserTemp[2]);

        {
          Procedure write() digunakan untuk menulis suatu string/variabel kedalam
          suatu file.
        }
        write(FileAdm,UserTemp);
    end;
    writeln('-------------------------------------');
    readln;clrscr;

    {
      Prosedur close digunakan untuk menutup file dan WAJIB dipanggil apabila
      semua operasi dengan file telah selesai
    }
    close(FileAdm);
end;

function Login(var FileAdm : FileAdmin; Usrnm, Pswd : string) : boolean;
{I.S. : Nama Pengguna (Usrnm) dan Kata Sandi (Pswd) sudah terdefinisi }
{F.S. : Menghasilkan fungsi login }
var
    {
      i digunakan untuk variabel bantuan penghitung sudah berapa kali user melakukan
      input username dan password.
      Array UserTemp digunakan sebagai penyimpanan sementara username dan password
      dalam memori untuk dibandingkan dengan masukkan user.
      Boolean Benar merupakan variabel bantuan untuk keluar dari loop ketika
      sudah ditemukan username dan password dalam file yang sesuai dengan
      masukkan user.
    }
    i        : integer;
    UserTemp : User;
    Benar    : boolean;
begin
    i := 1;
    Benar := false;

    {
      Perulangan while pertama untuk mengecek sudah berapa kali user melakukan input
    }
    while(i <= 3) and not Benar do
    begin
        {
          Prosedur reset digunakan untuk membuka suatu file dan menyimpan kursor
          pada bagian paling awal file tanpa menghapus isi data file
        }
        reset(FileAdm);

        {
          Perulangan kedua untuk mengecek apakah ada data yang dimasukkan user
          sesuai dengan data yang ada di file.
          Fungsi eof digunakan dari data satu ke data selanjutnya dan hanya
          mengembalikan nilai true, jika kursor berada dibagian paling akhir data.
        }
        while not eof(FileAdm) do
        begin
            {
              Prosedur read digunakan untuk menyimpan data dalam file kedalam
              suatu variabel
            }
            read(FileAdm,UserTemp);

            {
              Melakukan pengecekan, apakah data yang dimasukkan user sama dengan
              isi array UserTemp saat ini
            }
            if((Usrnm = UserTemp[1]) and (Pswd = UserTemp[2])) then
            begin
                Benar := true;
                {
                  Prosedur break, digunakan untuk keluar secara paksa dari perulangan
                }
                break;
            end;
        end;

        {
          Melakukan pengecekan, apabila data yang dimasukkan user salah, algoritma
          dibawah akan dieksekusi
        }
        if(not Benar) and (i <> 3) then
        begin
            textcolor(4);
            gotoxy(28,15);write('USERNAME ATAU PASSWORD SALAH!');textcolor(7);
            readln;gotoxy(28,15);clreol;gotoxy(44,13);clreol;
            gotoxy(44,12);clreol;
            gotoxy(44,12);readln(Usrnm);gotoxy(44,13);readln(Pswd);
        end;

        {
          Prosedur inc menggunakan parameter bertipe ByRef sehingga menambah
          nilai variabel yang di berikan. Sama dengan i := i + 1
        }
        inc(i);
    end;
    {
      Menutup file, karena tidak ada operasi dengan file lagi
    }
    close(FileAdm);

    {
      Melakukan pengecekan apakah, Benar bernilai true dimana Benar hanya akan
      bernilai true bila data yang dimasukkan user sama dengan data yang ada
      dalam file. Mengembalikan nilai true apabila benar bernilai true, vice versa
    }
    if Benar then
        Login := true
    else
        Login := false;
end;

procedure MenuPilihan (var Menu : integer);
{I.S. : User memilih salah satu menu }
{F.S. : Menghasilkan menu yang dipilih }
begin

    {
      Menampilkan pilihan-pilihan menu yang tersedia dalam aplikasi
    }
    gotoxy(25,8);write('MENU PILIHAN');
    gotoxy(25,9);write('============');
    gotoxy(25,10);write('1. Isi Data Obat');
    gotoxy(25,11);write('2. Cari Data Berdasarkan Nomer Faktur');
    gotoxy(25,12);write('3. Cari Data Berdasarkan Nama Obat');
    gotoxy(25,13);write('4. Cari Data Berdasarkan Tanggal Pembelian');
    gotoxy(25,14);write('5. Tampil Data Transaksi');
    gotoxy(25,15);write('0. Keluar');

    {
      Meminta masukkan user, untuk menu yang dipilih, serta validasi dimana menu
      yang dipilih tidak boleh kurang dari 0 atau lebih dari 5
    }
    gotoxy(25,17);write('MENU YANG ANDA PILIH : ');
    readln(Menu);
    while (Menu < 0) or (Menu > 5) do
    begin
        gotoxy(25,18);textcolor(4);
        write('MENU TIDAK DITEMUKAN!');readln;textcolor(7);
        gotoxy(25,18);clreol;
        gotoxy(48,17);clreol;
        readln(Menu);
    end;
end;


procedure IsiDataTransaksi(var FileTrsk : FileTransaksi);
{I.S. : User memasukkan jumlah data transaksi yang ingin dimasukkan }
{F.S. : Menghasilkan data transaksi yang tersimpan dalam file DataTransaksi.dat }
var

   {
    i digunakan sebagai iterator/perulangan
    Record Transaksi digunakan sebagai tempat penyimpanan sementara sebelum disimpan
    dalam file
   }
   i : integer;
   Transaksi : DataTransaksi;

begin

    {
      Mengecek apakah file sudah dibuat atau belum, apabila belum, file akan dibuka
      dalam mode reset, dan bila belum file akan dibuat dan dibuka dalam mode rewrite
    }
    if(FileExists('FileTransaksi.dat')) then
        reset(FileTrsk)
    else
        rewrite(FileTrsk);

    clrscr;write('Banyaknya Data Transaksi : ');readln(N);
    while (N < 0) do
    begin
        textcolor(4);
        writeln('BANYAK DATA PEMBELI TIDAK BOLEH KURANG DARI 0!');readln;
        textcolor(7);
        gotoxy(1,2);clreol;
        gotoxy(28,1);clreol;readln(N);
    end;

    clrscr;
    gotoxy(24,1);write('DATA TRANSAKSI');
    gotoxy(24,2);write('==============');
    gotoxy(1,4);
    writeln('--------------------------------------------------------------------------');
    writeln('| NO FAKTUR |     NAMA OBAT     | TANGGAL TRANSAKSI | JML | TOTAL HARGA  |');
    writeln('--------------------------------------------------------------------------');
    for i := 1 to N do
    begin
        gotoxy(1,i+6);
        write('|           |                   |                   |     |              |');
        gotoxy(3,i+6);readln(Transaksi.NoFaktur);
        gotoxy(15,i+6);readln(Transaksi.NamaObat);
        gotoxy(38,i+6);readln(Transaksi.TanggalTransaksi);
        gotoxy(55,i+6);readln(Transaksi.Jumlah);
        gotoxy(61,i+6);readln(Transaksi.Harga);

        {
          Prosedur write dipanggil untuk menyimpan nilai dari record transaksi
          kedalam file.
        }
        write(FileTrsk,Transaksi);
    end;
    write('--------------------------------------------------------------------------');
    close(FileTrsk);
    readln;
end;

procedure UrutData(var ArrTrsk : ArrTransaksi; N : integer);
{I.S. : Data Array yang bertiper Array Transaksi telah terdefinisi }
{F.S. : Menghasilkan Data Array yang telah terurut secara ascending }
var
   i,j  : integer;
   Temp : DataTransaksi;
begin
    for i := 1 to N-1 do
    begin
        for j := N downto i+1 do
        begin
            if(ArrTrsk[j].NoFaktur < ArrTrsk[j-1].NoFaktur) then
            begin
                Temp         := ArrTrsk[j];
                ArrTrsk[j]   := ArrTrsk[j-1];
                ArrTrsk[j-1] := Temp;
            end;
        end;
    end;
end;

procedure TampilData(var FileTrsk : FileTransaksi);
{I.S. : Data transaksi telat terdefinisi dan tersimpan dalam file FileTransaksi.dat }
{F.S. : Menampilkan data transaksi yang sudah terurut secara ascending berdasarkan nomer faktur}
var
    {
      N digunakan untuk menghitung banyaknya jumlah data yang ada dalam file
      ArrTrsk merupakan penyimpanan sementara file dalam memori yang nantinya
      akan di oper kedalam parameter urut dan ditampilkan
    }
    i, N : integer;
    ArrTrsk   : ArrTransaksi;
begin
    {
      Membuka file dalam mode reset
    }
    reset(FileTrsk);

    {
      Perulangan ini untuk menulis semua isi data dalam file kedalam array
    }
    N := 1;
    while not eof(FileTrsk) do
    begin
        read(FileTrsk,ArrTrsk[N]);
        inc(N);
    end;

    {
      Memanggil prosedur UrutData dengan array ArrTrsk sebagai parameter array
      yang ingin di urut, dan N-1 sebagai banyaknya jumlah array
    }
    UrutData(ArrTrsk,N-1);

    {
      Algoritma untuk menampilkan seluruh isi array ArrTrsk dalam bentuk tabel
    }
    clrscr;
    gotoxy(24,1);write('DATA TRANSAKSI');
    gotoxy(24,2);write('==============');
    gotoxy(1,4);
    writeln('--------------------------------------------------------------------------');
    writeln('| NO FAKTUR |     NAMA OBAT     | TANGGAL TRANSAKSI | JML | TOTAL HARGA  |');
    writeln('--------------------------------------------------------------------------');
    for i := 1 to N-1 do
    begin
        gotoxy(1,i+6);
        write('|           |                   |                   |     |              |');
        gotoxy(3,i+6);write(ArrTrsk[i].NoFaktur);
        gotoxy(15,i+6);write(ArrTrsk[i].NamaObat);
        gotoxy(38,i+6);write(ArrTrsk[i].TanggalTransaksi);
        gotoxy(55,i+6);write(ArrTrsk[i].Jumlah);
        gotoxy(61,i+6);writeln(ArrTrsk[i].Harga);
    end;
    write('--------------------------------------------------------------------------');
    readln;

    {
      Menutup file
    }
    close(FileTrsk);
end;


procedure CariFaktur(var FileTrsk : FileTransaksi);
{I.S. : User memasukkan nomer faktur yang ingin dicari }
{F.S. : Menampilkan data dengan nomer faktur sesuai masukkan user }
var
    Ia, Ib, N, K : integer;
    ArrTrsk   : ArrTransaksi;
    NoFaktur  : string;
    Ketemu    : boolean;
begin

    {
      Membuka file dalam mode reset
    }
    reset(FileTrsk);

    {
      Perulangan untuk menaruh seluruh data file kedalam memori array dan
      diurut berdasarkan nomer faktur secara ascending
    }
    N := 1;
    while not eof(FileTrsk) do
    begin
        read(FileTrsk,ArrTrsk[N]);
        inc(N);
    end;
    UrutData(ArrTrsk,N-1);

    {
      Meminta masukkan user, dan mengeksekusi algoritma binary search
    }
    clrscr;
    write('No Faktur yang dicari : '); readln(NoFaktur);
    Ia := 1; //  Inisialisasi ujung kiri array
    Ib := N; //  Inisialisasi ujung kanan array
    Ketemu := false;
    while(not Ketemu) and (Ia <= Ib) do
    begin
        K := (Ia + Ib) div 2;
        if(ArrTrsk[K].NoFaktur = NoFaktur) then
            ketemu := true
        else
            if(ArrTrsk[K].NoFaktur < NoFaktur) then
                Ia := K + 1
            else
                Ib := K -1;
    end;
    if(Ketemu) then
    begin
        clrscr;
        write('Data yang memiliki nomer faktur ',NoFaktur,' adalah sebagai berikut : ');
        gotoxy(1,3);
        writeln('Nama Obat         : ',ArrTrsk[K].NamaObat);
        writeln('Tanggal Transaksi : ',ArrTrsk[K].TanggalTransaksi);
        writeln('Jumlah            : ',ArrTrsk[K].Jumlah);
        writeln('Total Harga       : ',ArrTrsk[K].Harga);
    end
    else
    begin
        clrscr;write('DATA TRANSAKSI DENGAN NOMER FAKTUR ',NoFaktur,
                        ' TIDAK DITEMUKAN!');
    end;
    readln;close(FileTrsk);
end;

procedure CariNama(var FileTrsk : FileTransaksi; NamaObat : string);
{I.S. : Nama Obat yang dicari sudah terdefinisi }
{F.S. : Menampilkan data yang memiliki penggalan nama obat sama seperti yang
        dimasukkan user }
var
    Transaksi      : DataTransaksi;
    posawal, Baris : integer;
    Ketemu         : boolean;
begin
    {
      Membuka file dalam mode rese
    }
    reset(FileTrsk);

    {
      Inisialisasi variabel boolean bantuan
    }
    Ketemu := false;

    {
      Melakukan pengecekan apakah sudah ketemu dan file masih memiliki data
      selanjutnya
    }
    while(not Ketemu) and not eof(FileTrsk) do
    begin
        {
          Menyimpan isi data dalam file kedalam satu variabel sementara
        }
        read(FileTrsk,Transaksi);

        {
          Inisialiasi variabel posawal yang digunakan untuk menentukan posisi
          awal pengecekan potongan kata dari Nama Obat yang ada dalam file
        }
        posawal := 1;

        {
          Melakukan pengecekan, apakah posawal kurang dari selisih panjang nama
          obat dalam file dengan penggalan nama obat yang dicari, Karena jika posawal
          melebihi selisih tersebut, akan terjadi runtime error
        }
        while(posawal <= (length(Transaksi.NamaObat) - length(NamaObat) + 1)) do
        begin

            {
              Melakukan pengecekan apakah penggalan nama obat yang dicari dan dikapitalkan
              sama dengan penggalan nama obat dalam file yang dikapitalkan, dan panjang
              nama obat yang dicari tidak boleh sama dengan 0, atau user harus mengisi
              nama obat yang dicari
            }
            if((upcase(NamaObat) = upcase(copy(Transaksi.NamaObat,posawal,length(NamaObat)))) and
                (length(NamaObat) <> 0)) then
            begin
                {
                  Jika kondisi bernilai benar, maka variabel Ketemu akan berubah menjadi
                  true, dan prosedur break akan mengakhiri proses perulangan pengecekan
                  penggalan nama
                }
                Ketemu := true;
                break;
            end
            else
                {
                  Jika kondisi salah, maka nilai posawal akan bertambah 1
                }
                inc(posawal);
        end;
    end;
    {
      Menutup file
    }
    close(FileTrsk);

    {
      Melakukan pengecekan, jika berhasil ditemukan maka file akan diiterasi ulang
      dan langsung ditampilkan dalam bentuk tabel apabila berhasil ditemukan
    }
    if(Ketemu) then
    begin
        clrscr;gotoxy(24,1);write('DATA TRANSAKSI');
        gotoxy(24,2);write('==============');
        gotoxy(1,4);
        write('Data Dengan Nama Obat : ',NamaObat);
        gotoxy(1,6);
        writeln('--------------------------------------------------------------------------');
        writeln('| NO FAKTUR |     NAMA OBAT     | TANGGAL TRANSAKSI | JML | TOTAL HARGA  |');
        writeln('--------------------------------------------------------------------------');
        Baris := 8;
        reset(FileTrsk);
        while not eof(FileTrsk) do
        begin
            read(FileTrsk,Transaksi);
            posawal := 1;
            while(posawal <= (length(Transaksi.NamaObat) - length(NamaObat) + 1)) do
            begin
                if((upcase(NamaObat) = upcase(copy(Transaksi.NamaObat,posawal,length(NamaObat)))) and
                    (length(NamaObat) <> 0)) then
                begin
                    gotoxy(1,Baris+1);
                    write('|           |                   |                   |     |              |');
                    gotoxy(3,Baris+1);write(Transaksi.NoFaktur);
                    gotoxy(15,Baris+1);write(Transaksi.NamaObat);
                    gotoxy(38,Baris+1);write(Transaksi.TanggalTransaksi);
                    gotoxy(55,Baris+1);write(Transaksi.Jumlah);
                    gotoxy(61,Baris+1);writeln(Transaksi.Harga);
                    inc(Baris);
                    break;
                end
                else
                    inc(posawal);
            end;
        end;
        close(FileTrsk);
        write('--------------------------------------------------------------------------');
    end
    else
    begin
        clrscr;
        write('DATA TRANSAKSI DENGAN NAMA OBAT ',NamaObat,' TIDAK DITEMUKAN!');
    end;
    readln;
end;

procedure CariTanggal(var FileTrsk : FileTransaksi; Tanggal : string);
{I.S. : Tanggal yang dicari sudah terdefinisi }
{F.S. : Menampilkan semua data sesuai dengan tanggal yang dicari }
var
    baris     : integer;
    Transaksi : DataTransaksi;
begin
    {
      Membuka file dalam mode reset
    }
    reset(FileTrsk);

    {
      Melakukan iterasi pada file
    }
    while not eof(FileTrsk) do
    begin
        {
          Menyimpan data dalam file kedalam variabel sementara
        }
        read(FileTrsk,Transaksi);
        {
          Melakukan pengecekan apakah tanggal transaksi dalam variabel sementara
          sama dengan tanggal yang dicari
        }
        if(Transaksi.TanggalTransaksi = Tanggal) then
            {
              Memaksa perulangan untuk berhenti, bila benar ditemukan
            }
            break;
    end;
    {
      Menutup file
    }
    close(FileTrsk);

    {
      Melakukan pengecekan konfirmasi, apakah tanggal dalam variabel sementara
      sama dengan tanggal yang dicari, jika ya file akan diiterasi ulang dan
      langsung menampilkan data yang sama bila ditemukan dalam bentuk tabel
    }
    if(Transaksi.TanggalTransaksi = Tanggal) then
    begin
        clrscr;
        gotoxy(24,1);write('DATA TRANSAKSI');
        gotoxy(24,2);write('==============');
        gotoxy(1,4);
        write('Data Dengan Tanggal Transaksi : ',Tanggal);
        gotoxy(1,6);
        writeln('------------------------------------------------------');
        writeln('| NO FAKTUR |     NAMA OBAT     | JML | TOTAL HARGA  |');
        writeln('------------------------------------------------------');

        baris := 8;
        reset(FileTrsk);
        while not eof(FileTrsk) do
        begin
            read(FileTrsk,Transaksi);
            if(Transaksi.TanggalTransaksi = Tanggal) then
            begin
                gotoxy(1,Baris+1);
                writeln('|           |                   |     |              |');
                gotoxy(3,Baris+1);write(Transaksi.NoFaktur);
                gotoxy(15,Baris+1);write(Transaksi.NamaObat);
                gotoxy(35,Baris+1);write(Transaksi.Jumlah);
                gotoxy(41,Baris+1);writeln(Transaksi.Harga);
                inc(Baris);
            end
        end;
        gotoxy(1,baris+1);
        writeln('------------------------------------------------------');
        readln;
    end;
end;

{PROGRAM UTAMA}
begin
    {
      Prosedur assign untuk menghubungkan file dengan variabel
    }
    assign(FileTrsk,'FileTransaksi.dat');
    assign(FileAdm,'FileAdmin.dat');

    {
      Melakukan pengecekan apakah sudah ada user terdaftar, jika belum maka
      prosedur BuatUser akan dijalankan untuk mendaftarkan beberapa user admin
    }
    if(not FileExists('FileAdmin.dat')) then
        BuatUser(FileAdm);

    {
      Meminta masukkan user pertama kali untuk login
    }
    gotoxy(31,10);write('> > L O G I N < <');
    gotoxy(28,12);write('Nama Pengguna : ');readln(Usrnm);
    gotoxy(28,13);write('Kata Kunci    : ');readln(Pswd);

    {
      Melakukan pengecekan apakah login berhasil
    }
    if (Login(FileAdm,Usrnm,Pswd)) then
    begin
        {
          Jika login berhasil, maka program akan menampilkan menu pilihan
          hingga user melakukan exit aplikasi atau memilih keluar dalam menu
          pilihan
        }
        repeat
            clrscr;
            MenuPilihan(Menu);
            case (Menu) of
                1 : IsiDataTransaksi(FileTrsk);
                {
                  Sebelum prosedur masing-masing di eksekusi, semua menu akan melakukan
                  valdasi apakah file transaksi sudah ada atau belum,
                  jika belum, user akan diminta untu mengeksekusi menupilihan
                  nomer 1 terlebih dahulu.
                }
                2 : CariFaktur(FileTrsk);
                3 : begin
                        if(not fileexists('FileTransaksi.dat')) then
                        begin
                            textcolor(4);
                            write('DATA BELUM DITEMUKAN, SILAKAN MENGISI DATA TERLEBIH DAHULU!');
                            textcolor(7);readln
                        end
                        else
                        begin
                            clrscr;
                            write('Nama Obat yang dicari : ');readln(NamaObat);
                            CariNama(FileTrsk,NamaObat);
                        end;
                    end;
                4 : begin
                        if(not fileexists('FileTransaksi.dat')) then
                        begin
                            textcolor(4);
                            write('DATA BELUM DITEMUKAN, SILAKAN MENGISI DATA TERLEBIH DAHULU!');
                            textcolor(7);readln
                        end
                        else
                        begin
                            clrscr;
                            write('Tanggal Transaksi yang dicari : ');
                            readln(Tanggal);
                            CariTanggal(FileTrsk,Tanggal);
                        end;
                    end;
                5 : begin
                        if(not fileexists('FileTransaksi.dat')) then
                        begin
                            textcolor(4);
                            write('DATA BELUM DITEMUKAN, SILAKAN MENGISI DATA TERLEBIH DAHULU!');
                            textcolor(7);readln
                        end
                        else
                            TampilData(FileTrsk);
                    end;
            end;
        until(Menu=0);
    end
    else
    begin
        {
          Jika login gagal hingga 3 kali, maka aplikasi akan secara paksa keluar
        }
        textcolor(4);gotoxy(28,15);
        write('ANDA SUDAH SALAH TIGA KALI!');readln;
    end;
end.
