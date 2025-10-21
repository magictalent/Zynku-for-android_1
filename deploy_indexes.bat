@echo off
echo Deploying Firestore indexes...
firebase deploy --only firestore:indexes
echo Indexes deployed successfully!
pause
