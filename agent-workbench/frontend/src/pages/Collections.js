import React, { useState, useEffect } from 'react';
import { Card, Button, Table, Modal, Form, Input, Select, Row, Col, Tag } from 'antd';
import { PlusOutlined } from '@ant-design/icons';
import axios from 'axios';

const Collections = () => {
  const [collections, setCollections] = useState([]);
  const [isModalVisible, setIsModalVisible] = useState(false);
  const [form] = Form.useForm();
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    fetchCollections();
  }, []);

  const fetchCollections = async () => {
    try {
      setLoading(true);
      const response = await axios.get('/api/collections');
      setCollections(response.data);
    } catch (error) {
      console.error('Failed to fetch collections:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleCreateCollection = async (values) => {
    try {
      await axios.post('/api/collections', values);
      setIsModalVisible(false);
      form.resetFields();
      fetchCollections();
    } catch (error) {
      console.error('Failed to create collection:', error);
    }
  };

  const columns = [
    { title: 'Borrower ID', dataIndex: 'borrowerId', key: 'borrowerId' },
    { title: 'Loan ID', dataIndex: 'loanId', key: 'loanId' },
    { title: 'Amount', dataIndex: 'outstandingAmount', key: 'outstandingAmount' },
    { 
      title: 'Status', 
      dataIndex: 'status', 
      key: 'status',
      render: (status) => {
        const colors = {
          'ACTIVE': 'blue',
          'SETTLED': 'green',
          'PENDING': 'orange'
        };
        return <Tag color={colors[status] || 'default'}>{status}</Tag>;
      }
    },
    { title: 'DPD', dataIndex: 'dpdBucket', key: 'dpdBucket' },
    { title: 'Created', dataIndex: 'createdAt', key: 'createdAt' }
  ];

  return (
    <div>
      <Row justify="space-between" style={{ marginBottom: '24px' }}>
        <h2>Collections Management</h2>
        <Button 
          type="primary" 
          icon={<PlusOutlined />}
          onClick={() => setIsModalVisible(true)}
        >
          New Collection
        </Button>
      </Row>

      <Card>
        <Table 
          columns={columns} 
          dataSource={collections}
          loading={loading}
          pagination={{ pageSize: 20 }}
          rowKey="id"
        />
      </Card>

      <Modal
        title="Create New Collection"
        visible={isModalVisible}
        onCancel={() => setIsModalVisible(false)}
        footer={null}
      >
        <Form
          form={form}
          layout="vertical"
          onFinish={handleCreateCollection}
        >
          <Form.Item
            label="Borrower ID"
            name="borrowerId"
            rules={[{ required: true, message: 'Please enter borrower ID' }]}
          >
            <Input />
          </Form.Item>

          <Form.Item
            label="Loan ID"
            name="loanId"
            rules={[{ required: true, message: 'Please enter loan ID' }]}
          >
            <Input />
          </Form.Item>

          <Form.Item
            label="Outstanding Amount"
            name="outstandingAmount"
            rules={[{ required: true, message: 'Please enter amount' }]}
          >
            <Input type="number" />
          </Form.Item>

          <Form.Item
            label="DPD Bucket"
            name="dpdBucket"
            rules={[{ required: true, message: 'Please select DPD bucket' }]}
          >
            <Select placeholder="Select DPD Bucket">
              <Select.Option value="1-30">1-30 Days</Select.Option>
              <Select.Option value="31-60">31-60 Days</Select.Option>
              <Select.Option value="61-90">61-90 Days</Select.Option>
              <Select.Option value="90+">90+ Days</Select.Option>
            </Select>
          </Form.Item>

          <Form.Item>
            <Button type="primary" htmlType="submit" block>
              Create Collection
            </Button>
          </Form.Item>
        </Form>
      </Modal>
    </div>
  );
};

export default Collections;
