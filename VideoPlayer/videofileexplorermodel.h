#ifndef VIDEOFILEEXPLORERMODEL_H
#define VIDEOFILEEXPLORERMODEL_H

#include "exploreritem.h"

#include <qqml.h>
#include <QObject>
#include <QStringList>
#include <QUrl>
#include <QAbstractListModel>

class VideoFileExplorerModel : public QAbstractListModel, public QQmlParserStatus
{
    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)

    Q_PROPERTY(QUrl folder READ folder WRITE setFolder NOTIFY folderChanged)
    Q_PROPERTY(QUrl rootFolder READ rootFolder WRITE setRootFolder)


public:

    enum FilesRoles {
        IsFolderRole = Qt::UserRole + 1,
        UrlRole,
        NameRole
    };

//    struct stFileItem
//    {
//        stFileItem() {}
//        bool isFolder;
//        QString url;
//        QString name;
//    };


    explicit VideoFileExplorerModel(QObject *parent = nullptr);
    ~VideoFileExplorerModel();

    // QAbstractListModel interface
    QHash<int, QByteArray> roleNames() const;
    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    QModelIndex index(int row, int column, const QModelIndex &parent) const;

    // QQmlParserStatus interface
    void classBegin();
    void componentComplete();

    QUrl folder() const;
    void setFolder(const QUrl &folder);
    QUrl rootFolder() const;
    void setRootFolder(const QUrl &path);

private slots:

    void directoryChanged(const QString &directory, const QList<ExplorerItem> &list);
    void directoryUpdated(const QString &directory, const QList<ExplorerItem> &list, int fromIndex, int toIndex);


signals:
    void folderChanged();
    void rowCountChanged() const;

private:

    class PrivateData;
    PrivateData * p_data;





    // QAbstractItemModel interface
public:
};

#endif // VIDEOFILEEXPLORERMODEL_H
