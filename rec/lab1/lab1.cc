/*Consider a structure named Student with attributes as SID, NAME,
BRANCH, SEMESTER, ADDRESS.
Write a program in C/C++/ and perform the following operations
using the concept of files.
a. Insert a new student
b. Modify the address of the student based on SID
c. Delete a student
d. List all the students
e. List all the students of CSE branch.
f. List all the students of CSE branch and reside in Kuvempunagar.
*/

//Note: clear .dat file before running the program for the first time to avoid garbage values.

#include <iostream>
#include <fstream>
#include <cstring>
using namespace std;

struct Student {
    int sid;
    char name[30];
    char branch[10];
    int sem;
    char address[50];
};

void insert() {
    Student s;
    ofstream f("students.dat", ios::app | ios::binary);
    cout << "Enter SID, Name, Branch, Sem, Address: ";
    cin >> s.sid;
    cin.ignore();   // Ignore the newline character after reading SID
    cin.getline(s.name, 30);
    cin >> s.branch >> s.sem;
    cin.ignore();
    cin.getline(s.address, 50);
    f.write((char*)&s, sizeof(s));
    f.close();
    cout << "Inserted\n";
}

void modify() {
    int id;
    char newAddr[50];
    cout << "Enter SID to modify: ";
    cin >> id;
    cin.ignore();
    cout << "Enter new Address: ";
    cin.getline(newAddr, 50);

    fstream f("students.dat", ios::in | ios::out | ios::binary);
    Student s;
    bool found = false;
    while (f.read((char*)&s, sizeof(s))) {
        if (s.sid == id) {
            strcpy(s.address, newAddr);
            f.seekp(-sizeof(s), ios::cur);
            f.write((char*)&s, sizeof(s));
            found = true;
            break;
        }
    }
    f.close();
    cout << (found ? "Modified\n" : "Not found\n");
}

void del() {
    int id;
    cout << "Enter SID to delete: ";
    cin >> id;

    ifstream fin("students.dat", ios::binary);
    ofstream fout("temp.dat", ios::binary);
    Student s;
    bool found = false;
    while (fin.read((char*)&s, sizeof(s))) {
        if (s.sid != id)
            fout.write((char*)&s, sizeof(s));
        else
            found = true;
    }
    fin.close();
    fout.close();
    remove("students.dat");
    rename("temp.dat", "students.dat");
    cout << (found ? "Deleted\n" : "Not found\n");
}

void listAll() {
    ifstream f("students.dat", ios::binary);
    Student s;
    cout << "\nSID\tName\tBranch\tSem\tAddress\n";
    while (f.read((char*)&s, sizeof(s)))
        cout << s.sid << "\t" << s.name << "\t" << s.branch << "\t" << s.sem << "\t" << s.address << endl;
    f.close();
}

void listCSE() {
    ifstream f("students.dat", ios::binary);
    Student s;
    cout << "\nCSE Students:\nSID\tName\tSem\tAddress\n";
    while (f.read((char*)&s, sizeof(s)))
        if (strcmp(s.branch, "CSE") == 0)
            cout << s.sid << "\t" << s.name << "\t" << s.sem << "\t" << s.address << endl;
    f.close();
}

void listCSEKuv() {
    ifstream f("students.dat", ios::binary);
    Student s;
    cout << "\nCSE + Kuvempunagar:\nSID\tName\tSem\tAddress\n";
    while (f.read((char*)&s, sizeof(s)))
        if (strcmp(s.branch, "CSE") == 0 && strstr(s.address, "Kuvempunagar"))
            cout << s.sid << "\t" << s.name << "\t" << s.sem << "\t" << s.address << endl;
    f.close();
}

int main() {
    int ch;
    do {
        cout << "\n1.Insert \n2.Modify Addr \n3.Delete \n4.List All\n"
             << "5.List CSE \n6.List CSE+Kuvempunagar \n7.Exit\nChoice: ";
        cin >> ch;
        switch (ch) {
            case 1: insert(); break;
            case 2: modify(); break;
            case 3: del(); break;
            case 4: listAll(); break;
            case 5: listCSE(); break;
            case 6: listCSEKuv(); break;
        }
    } while (ch != 7);
    return 0;
}