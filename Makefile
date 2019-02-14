
run:
	./gradlew run


setup-db:
	sqlite3 applications.sqlite < setup-db.sql
