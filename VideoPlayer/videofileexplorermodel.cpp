#include "videofileexplorermodel.h"
#include "videofileexplorerthread.h"

#include <QList>
#include <QDir>
#include <qqmlfile.h>

class VideoFileExplorerModel::PrivateData {
public:

    QList<ExplorerItem>files;
    QUrl currentDir;
    QUrl rootFolder;
    VideoFileExplorerThread videoInfoThread;

    static QString resolvePath(const QUrl &path)
    {
        QString localPath = QQmlFile::urlToLocalFileOrQrc(path);
        QUrl localUrl = QUrl(localPath);
        QString fullPath = localUrl.path();
        if (localUrl.scheme().length())
          fullPath = localUrl.scheme() + ":" + fullPath;
        return QDir::cleanPath(fullPath);
    }

};

VideoFileExplorerModel::VideoFileExplorerModel(QObject *parent) : QAbstractListModel(parent)
{
    p_data = new PrivateData;
    qRegisterMetaType<QList<ExplorerItem> >("QList<ExplorerItem>");
    connect(&p_data->videoInfoThread , &VideoFileExplorerThread::directoryChanged, this, &VideoFileExplorerModel::directoryChanged);
    connect(&p_data->videoInfoThread , &VideoFileExplorerThread::directoryUpdated, this, &VideoFileExplorerModel::directoryUpdated);
}

VideoFileExplorerModel::~VideoFileExplorerModel()
{
    p_data->files.clear();
    delete p_data;
}

QHash<int, QByteArray> VideoFileExplorerModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IsFolderRole] = "isfolder";
    roles[UrlRole] = "url";
    roles[NameRole] = "name";
    return roles;
}

int VideoFileExplorerModel::rowCount(const QModelIndex &) const
{
    return p_data->files.count();
}

QVariant VideoFileExplorerModel::data(const QModelIndex &index, int role) const
{
    QVariant rv;

    if(index.row() >= p_data->files.size()){
        return rv;
    }

    switch (role) {
    case IsFolderRole:
        rv = p_data->files.at(index.row()).isDir();
        break;
    case UrlRole:
        rv = p_data->files.at(index.row()).filePath();
        break;
    case NameRole:
        rv = p_data->files.at(index.row()).fileName();
        break;
    default:
        break;
    }

    return rv;
}

QModelIndex VideoFileExplorerModel::index(int row, int , const QModelIndex &) const
{
     return createIndex(row, 0);
}

void VideoFileExplorerModel::classBegin()
{
}

void VideoFileExplorerModel::componentComplete()
{
    QString localPath = QQmlFile::urlToLocalFileOrQrc(p_data->currentDir);
    if (localPath.isEmpty() || !QDir(localPath).exists())
        setFolder(QUrl::fromLocalFile(QDir::currentPath()));
}

QUrl VideoFileExplorerModel::folder() const
{
    return p_data->currentDir;
}

void VideoFileExplorerModel::setFolder(const QUrl &folder)
{
    if (folder == p_data->currentDir)
        return;

    QString resolvedPath = p_data->resolvePath(folder);

    beginResetModel();

    p_data->currentDir = folder;

    QFileInfo info(resolvedPath);
    if (!info.exists() || !info.isDir()) {
        p_data->files.clear();
        endResetModel();
        emit rowCountChanged();
        return;
    }

    p_data->videoInfoThread.setPath(resolvedPath);
}

QUrl VideoFileExplorerModel::rootFolder() const
{
    return p_data->rootFolder;
}

void VideoFileExplorerModel::setRootFolder(const QUrl &path)
{
    if (path.isEmpty())
        return;

    QString resolvedPath = p_data->resolvePath(path);
    p_data->rootFolder = path;

    QFileInfo info(resolvedPath);
    if (!info.exists() || !info.isDir())
        return;

    p_data->videoInfoThread.setRootPath(resolvedPath);
    p_data->rootFolder = path;
}

void VideoFileExplorerModel::directoryChanged(const QString &directory, const QList<ExplorerItem> &list)
{
    Q_UNUSED(directory)
    p_data->files = list;
    endResetModel();
    emit rowCountChanged();
    emit folderChanged();
}

void VideoFileExplorerModel::directoryUpdated(const QString &directory, const QList<ExplorerItem> &list, int fromIndex, int toIndex)
{
    Q_UNUSED(directory);

    QModelIndex parent;
    if (p_data->files.size() == list.size()) {
        QModelIndex modelIndexFrom = createIndex(fromIndex, 0);
        QModelIndex modelIndexTo = createIndex(toIndex, 0);
        p_data->files = list;
        emit dataChanged(modelIndexFrom, modelIndexTo);
    } else {
        if (p_data->files.size() > 0) {
            beginRemoveRows(parent, 0, p_data->files.size() - 1);
            endRemoveRows();
        }
        p_data->files = list;
        if (list.size() > 0) {
            if (toIndex > list.size() - 1)
                toIndex = list.size() - 1;
            beginInsertRows(parent, 0, p_data->files.size() - 1);
            endInsertRows();
        }
        emit rowCountChanged();
    }
}
