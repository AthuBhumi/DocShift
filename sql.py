import sqlite3

conn = sqlite3.connect('file_conversion.db')
c = conn.cursor()

c.execute('''
CREATE TABLE IF NOT EXISTS conversions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    conversion_type TEXT NOT NULL,
    original_filename TEXT NOT NULL,
    converted_filename TEXT NOT NULL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
)
''')

conn.commit()
conn.close()
print("Database initialized.")
