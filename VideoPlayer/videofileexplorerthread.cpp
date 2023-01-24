#include "videofileexplorerthread.h"

VideoFileExplorerThread::VideoFileExplorerThread(QObject *parent)
    : QThread(parent),
      sortFlags(QDir::Name),
      abort(false),
      needUpdate(true),
      folderUpdate(false)
{
    start(LowPriority);
}

VideoFileExplorerThread::~VideoFileExplorerThread()
{
    QMutexLocker locker(&mutex);
    abort = true;
    condition.wakeOne();
    locker.unlock();
    wait();
}

void VideoFileExplorerThread::setPath(const QString &path)
{
    Q_ASSERT(!path.isEmpty());
    currentPath = path;
    needUpdate = true;
    condition.wakeAll();
}

void VideoFileExplorerThread::setRootPath(const QString &path)
{
    Q_ASSERT(!path.isEmpty());

    QMutexLocker locker(&mutex);
    rootPath = path;
}

void VideoFileExplorerThread::dirChanged(const QString &directoryPath)
{
    Q_UNUSED(directoryPath);
    QMutexLocker locker(&mutex);
    folderUpdate = true;
    condition.wakeAll();
}

void VideoFileExplorerThread::run()
{

    forever {
        bool updateFiles = false;
        QMutexLocker locker(&mutex);
        if (abort) {
            return;
        }
        if (currentPath.isEmpty() || !needUpdate)
            condition.wait(&mutex);

        if (abort) {
            return;
        }

        if (!currentPath.isEmpty()) {
            updateFiles = true;
        }
        if (updateFiles)
            getFileInfos(currentPath);
        locker.unlock();
    }
}

void VideoFileExplorerThread::getFileInfos(const QString &path)
{
    QDir::Filters filter;
    filter = QDir::CaseSensitive;
    filter = filter | QDir::Files;
    filter = filter | QDir::AllDirs | QDir::Drives;
    filter = filter | QDir::Readable;
    sortFlags = sortFlags | QDir::DirsFirst;

    QDir currentDir(path, QString(), sortFlags);
    QFileInfoList fileInfoList;
    QList<ExplorerItem> filePropertyList;
    QStringList nameFilters;
    nameFilters << "*.mp4" << "*.mov" << "*.avi" << "*.mkv";

    fileInfoList = currentDir.entryInfoList(nameFilters, filter, sortFlags);

    if (!fileInfoList.isEmpty()) {
        filePropertyList.reserve(fileInfoList.count());
        foreach (const QFileInfo &info, fileInfoList) {
            filePropertyList << ExplorerItem(info);
        }
        if (folderUpdate) {
            int fromIndex = 0;
            int toIndex = currentFileList.size()-1;
            findChangeRange(filePropertyList, fromIndex, toIndex);
            folderUpdate = false;
            currentFileList = filePropertyList;
            emit directoryUpdated(path, filePropertyList, fromIndex, toIndex);
        } else {
            currentFileList = filePropertyList;
            emit directoryUpdated(path, filePropertyList, 0, currentFileList.size()-1);
        }
    } else {
        if (folderUpdate) {
            int fromIndex = 0;
            int toIndex = currentFileList.size()-1;
            folderUpdate = false;
            currentFileList.clear();
            emit directoryUpdated(path, filePropertyList, fromIndex, toIndex);
        } else {
            currentFileList.clear();
            emit directoryChanged(path, filePropertyList);
        }
    }
    needUpdate = false;
}

void VideoFileExplorerThread::findChangeRange(const QList<ExplorerItem> &list, int &fromIndex, int &toIndex)
{
    if (currentFileList.size() == 0) {
        fromIndex = 0;
        toIndex = list.size();
        return;
    }

    int i;
    int listSize = list.size() < currentFileList.size() ? list.size() : currentFileList.size();
    bool changeFound = false;

    for (i=0; i < listSize; i++) {
        if (list.at(i) != currentFileList.at(i)) {
            changeFound = true;
            break;
        }
    }

    if (changeFound)
        fromIndex = i;
    else
        fromIndex = i-1;

    toIndex = list.size() > currentFileList.size() ? list.size() - 1 : currentFileList.size() - 1;
}
