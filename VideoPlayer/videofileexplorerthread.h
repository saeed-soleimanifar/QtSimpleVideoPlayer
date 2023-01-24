#ifndef VIDEOFILEEXPLORERTHREAD_H
#define VIDEOFILEEXPLORERTHREAD_H


#include <QThread>
#include <QMutex>
#include <QWaitCondition>
#include <QFileSystemWatcher>
#include <QFileInfo>
#include <QDir>

#include "exploreritem.h"

class VideoFileExplorerThread : public QThread
{
    Q_OBJECT
public:
    explicit VideoFileExplorerThread(QObject *parent = nullptr);
    ~VideoFileExplorerThread();

    void setPath(const QString &path);
    void setRootPath(const QString &path);

public slots:
    void dirChanged(const QString &directoryPath);

signals:

    void directoryChanged(const QString &directory, const QList<ExplorerItem> &list) const;
    void directoryUpdated(const QString &directory, const QList<ExplorerItem> &list, int fromIndex, int toIndex) const;

private:

    QList<ExplorerItem> currentFileList;
    QDir::SortFlags sortFlags;
    QMutex mutex;
    QWaitCondition condition;
    volatile bool abort;
    QString currentPath;
    QString rootPath;
    bool needUpdate;
    bool folderUpdate;


    // QThread interface
protected:
    void run();
    void getFileInfos(const QString &path);
    void findChangeRange(const QList<ExplorerItem> &list, int &fromIndex, int &toIndex);
};

#endif // VIDEOFILEEXPLORERTHREAD_H
